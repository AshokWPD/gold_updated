import 'package:flutter/material.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_web/components/user_communication_drawer.dart';
import 'package:goltens_web/pages/message/message_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:goltens_web/components/chat_text_field.dart';
import 'package:goltens_core/models/auth.dart';
import 'package:goltens_core/models/group.dart';
import 'package:goltens_core/models/message.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_core/services/message.dart';
import 'package:goltens_core/components/message_card.dart';

class UserGroupDetailPage extends StatefulWidget {
  const UserGroupDetailPage({super.key, int? groupId});

  @override
  State<UserGroupDetailPage> createState() => _UserGroupDetailPageState();
}

class _UserGroupDetailPageState extends State<UserGroupDetailPage> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<GlobalState>().user;

    switch (user?.data.type) {
      case UserType.admin:
      case UserType.subAdmin:
      case UserType.userAndSubAdmin:
        return const GroupDetailAdminPage();
      case UserType.user:
        return const GroupDetailUserPage();
      case null:
        throw Exception('User Not Logged In');
    }
  }
}

class GroupDetailUserPage extends StatefulWidget {
  const GroupDetailUserPage({super.key});

  @override
  State<GroupDetailUserPage> createState() => _GroupDetailUserPageState();
}

class _GroupDetailUserPageState extends State<GroupDetailUserPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  List<GetMessagesResponseData> readMessages = [];
  List<GetMessagesResponseData> unreadMessages = [];
  bool isReadLoading = false;
  bool isUnreadLoading = false;
  bool hasReadMoreData = true;
  bool hasUnreadMoreData = true;
  bool hasError = true;
  String filter = 'unread';
  String query = '';
  int readPage = 1;
  int unreadPage = 1;
  final int limit = 20;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(tabListener);
    scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        fetchMessages(false);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    bool outOfRange = scrollController.position.outOfRange;
    double offset = scrollController.offset;

    if (offset >= scrollController.position.maxScrollExtent && !outOfRange) {
      fetchMessages(false);
    }
  }

  void tabListener() {
    switch (tabController.index) {
      case 0:
        setState(() {
          filter = 'unread';
        });
        break;
      case 1:
        setState(() {
          filter = 'read';
        });
        break;
      default:
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        fetchMessages(false);
      }
    });
  }

  Future<void> fetchMessages(bool refresh) async {
    bool loading = filter == 'read' ? isReadLoading : isUnreadLoading;
    bool hasMoreData = filter == 'read' ? hasReadMoreData : hasUnreadMoreData;

    if (!refresh) {
      if (loading || !hasMoreData) return;
    } else {
      if (loading) return;

      setState(() {
        if (filter == 'read') {
          readPage = 1;
          readMessages = [];
        } else {
          unreadPage = 1;
          unreadMessages = [];
        }
      });
    }

    setState(() {
      if (filter == 'read') {
        isReadLoading = true;
      } else {
        isUnreadLoading = true;
      }

      hasError = false;
    });

    try {
      final settings = ModalRoute.of(context)!.settings;
      final group = settings.arguments as GetAllGroupsResponseData;
      int page = filter == 'read' ? readPage : unreadPage;

      var getMessagesResponse = await MessageService.getMessages(
        group.id,
        page,
        limit,
        filter,
        query,
      );

      setState(() {
        if (filter == 'read') {
          readMessages.addAll(getMessagesResponse.data);
          isReadLoading = false;
          hasReadMoreData = getMessagesResponse.data.length == limit;
          readPage++;
        } else {
          unreadMessages.addAll(getMessagesResponse.data);
          isUnreadLoading = false;
          hasUnreadMoreData = getMessagesResponse.data.length == limit;
          unreadPage++;
        }
      });
    } catch (error) {
      setState(() {
        isReadLoading = false;
        isUnreadLoading = false;
        hasError = true;
      });
    }
  }

  Widget buildMessageList(String itemToRender) {
    List<GetMessagesResponseData> messages;

    if (itemToRender == 'read') {
      messages = readMessages;
    } else {
      messages = unreadMessages;
    }

    if (isReadLoading || isUnreadLoading) {
      return buildLoader();
    }

    if (messages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No Messages Available',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      );
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Error Fetching Data, Please Try Again',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () => fetchMessages(true),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_outlined),
                  SizedBox(width: 5),
                  Text('Retry'),
                ],
              ),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => fetchMessages(true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: messages.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == messages.length) {
            return buildLoader();
          }

          GetMessagesResponseData message = messages[index];
          var time = formatDateTime(message.createdAt, 'HH:mm dd/MM/y');
          String? imageUrl;

          if (message.files.isNotEmpty) {
            var image = message.files.firstWhere(
              (element) => element.fileType == 'image',
              orElse: () => Files(name: '', fileType: ''),
            );

            var pdf = message.files.firstWhere(
              (element) => element.name.endsWith('.pdf'),
              orElse: () => Files(name: '', fileType: ''),
            );

            if (pdf.name.isNotEmpty) {
              imageUrl = pdf.name.replaceAll('.pdf', '.jpg');
            }

            if (image.name.isNotEmpty) {
              imageUrl = image.name;
            }
          }

          var messageId = formatDateTime(
            message.createdAt,
            'yyMM\'SN${message.id}\'',
          );

          return MessageCard(
            messageId: messageId,
            title: message.title,
            content: message.content,
            showFullContent: false,
            createdByAvatar: message.createdBy.avatar,
            createdByName: message.createdBy.name,
            imageUrl: imageUrl,
            isUnread: null,
            files: message.files,
            time: time,
            onTap: () async {
              final settings = ModalRoute.of(context)!.settings;
              final group = settings.arguments as GetAllGroupsResponseData;

              // Leave Navigation As It Is
              final reload = await Navigator.pushNamed(
                context,
                '/message-detail',
                arguments: MessageDetailPageArgs(
                  message: message,
                  group: group,
                ),
              );

              if (reload == null) {
                await fetchMessages(true);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildLoader() {
    if (filter == 'read' && !hasReadMoreData) {
      return Container();
    }

    if (filter == 'unread' && !hasUnreadMoreData) {
      return Container();
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)!.settings;
    final group = settings.arguments as GetAllGroupsResponseData;
    var isMobile = MediaQuery.of(context).size.width < 500;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: Text('Communication Page'),
      )
          : null,
      drawer: isMobile ? UserCommunicationDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) const UserCommunicationDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                query.isNotEmpty
                                    ? 'Results for "$query"'
                                    : group.name,
                                style: TextStyle(
                                  fontSize: isMobile ? 28.0 : 32.0,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  // Leave Navigation As It Is
                                  Navigator.pushNamed(
                                    context,
                                    '/group-info',
                                    arguments: group,
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.info),
                                    SizedBox(width: 5.0),
                                    Text('Group Info')
                                  ],
                                ),
                              ),
                            ],
                          ),
                          TabBar(
                            controller: tabController,
                            labelColor: Theme.of(context).primaryColor,
                            tabs: const [
                              Tab(text: 'Unread'),
                              Tab(text: 'Read'),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: tabController,
                  children: [
                    buildMessageList('unread'),
                    buildMessageList('read'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupDetailAdminPage extends StatefulWidget {
  const GroupDetailAdminPage({super.key});

  @override
  State<GroupDetailAdminPage> createState() => _GroupDetailAdminPageState();
}

class _GroupDetailAdminPageState extends State<GroupDetailAdminPage> {
  ScrollController scrollController = ScrollController();
  List<GetMessagesResponseData> messages = [];
  bool isLoading = false;
  bool hasMoreData = true;
  bool hasError = true;
  String filter = 'all';
  String query = '';
  int page = 1;
  final int limit = 20;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        fetchMessages(false);
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  void scrollListener() {
    bool outOfRange = scrollController.position.outOfRange;
    double offset = scrollController.offset;

    if (offset >= scrollController.position.maxScrollExtent && !outOfRange) {
      fetchMessages(false);
    }
  }

  Future<void> fetchMessages(bool refresh) async {
    if (!refresh) {
      if (isLoading || !hasMoreData) return;
    } else {
      if (isLoading) return;

      setState(() {
        page = 1;
        messages = [];
      });
    }

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final settings = ModalRoute.of(context)!.settings;
      final group = settings.arguments as GetAllGroupsResponseData;

      var getMessagesResponse = await MessageService.getMessages(
        group.id,
        page,
        limit,
        filter,
        query,
      );

      setState(() {
        messages.addAll(getMessagesResponse.data);
        isLoading = false;
        hasMoreData = getMessagesResponse.data.length == limit;
        page++;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void sendMessage(
    String title,
    String message,
    int timer,
    List<Map<String, dynamic>> filesArr,
  ) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return const Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text('Loading...')
              ],
            ),
          ),
        );
      },
    );

    final settings = ModalRoute.of(context)!.settings;
    final group = settings.arguments as GetAllGroupsResponseData;

    try {
      var res = await MessageService.createMessage(
        group.id,
        title,
        message,
        timer,
        filesArr,
      );

      if (mounted) Navigator.of(context).pop();
      setState(() => messages.insert(0, res));

      if (messages.length > 1) {
        scrollController.animateTo(
          0,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)!.settings;
    final group = settings.arguments as GetAllGroupsResponseData;
    var isMobile = MediaQuery.of(context).size.width < 500;

    return Scaffold(
      body: Row(
        children: [
          const UserCommunicationDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                query.isNotEmpty
                                    ? 'Results for "$query"'
                                    : group.name,
                                style: TextStyle(
                                  fontSize: isMobile ? 28.0 : 32.0,
                                ),
                              ),
                              Row(
                                children: isMobile
                                    ? [
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Leave Navigation As It Is
                                            Navigator.pushNamed(
                                              context,
                                              '/manage-members',
                                              arguments: group,
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.info),
                                              SizedBox(width: 5.0),
                                              Text('Manage Members')
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Leave Navigation As It Is
                                            Navigator.pushNamed(
                                              context,
                                              '/group-info',
                                              arguments: group,
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.info),
                                              SizedBox(width: 5.0),
                                              Text('Group Info')
                                            ],
                                          ),
                                        ),
                                      ]
                                    : [
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Leave Navigation As It Is
                                            Navigator.pushNamed(
                                              context,
                                              '/manage-members',
                                              arguments: group,
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.manage_accounts),
                                              SizedBox(width: 5.0),
                                              Text('Manage Members')
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Leave Navigation As It Is
                                            Navigator.pushNamed(
                                              context,
                                              '/group-info',
                                              arguments: group,
                                            );
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.info),
                                              SizedBox(width: 5.0),
                                              Text('Group Info')
                                            ],
                                          ),
                                        ),
                                      ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ];
                },
                body: Stack(
                  children: [
                    buildMessageList(),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: ChatTextField(onMessageSend: sendMessage),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageList() {
    final settings = ModalRoute.of(context)!.settings;
    final group = settings.arguments as GetAllGroupsResponseData;
    final unreadMessages = group.unreadMessages;

    if (isLoading && messages.isEmpty) {
      return buildLoader();
    }

    if (hasError) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Error Fetching Data, Please Try Again',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () => fetchMessages(true),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.replay_outlined),
                  SizedBox(width: 5),
                  Text('Retry'),
                ],
              ),
            )
          ],
        ),
      );
    }

    if (messages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'No Messages Available',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => fetchMessages(true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100.0),
        controller: scrollController,
        itemCount: messages.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == messages.length) {
            return buildLoader();
          }

          GetMessagesResponseData message = messages[index];
          var isUnread = unreadMessages.any((e) => e.id == message.id);
          var time = formatDateTime(message.createdAt, 'HH:mm dd/MM/y');
          String? imageUrl;

          if (message.files.isNotEmpty) {
            var image = message.files.firstWhere(
              (element) => element.fileType == 'image',
              orElse: () => Files(name: '', fileType: ''),
            );

            var pdf = message.files.firstWhere(
              (element) => element.name.endsWith('.pdf'),
              orElse: () => Files(name: '', fileType: ''),
            );

            if (pdf.name.isNotEmpty) {
              imageUrl = pdf.name.replaceAll('.pdf', '.jpg');
            }

            if (image.name.isNotEmpty) {
              imageUrl = image.name;
            }
          }

          var messageId = formatDateTime(
            message.createdAt,
            'yyMM\'SN${message.id}\'',
          );

          return MessageCard(
            messageId: messageId,
            title: message.title,
            content: message.content,
            showFullContent: false,
            createdByAvatar: message.createdBy.avatar,
            createdByName: message.createdBy.name,
            imageUrl: imageUrl,
            isUnread: isUnread,
            files: message.files,
            time: time,
            onTap: () async {
              final settings = ModalRoute.of(context)!.settings;
              final group = settings.arguments as GetAllGroupsResponseData;

              // Leave Navigation As It Is
              final reload = await Navigator.pushNamed(
                context,
                '/message-detail',
                arguments: MessageDetailPageArgs(
                  message: message,
                  group: group,
                ),
              );

              if (reload == null) {
                await fetchMessages(true);
              }
            },
          );
        },
      ),
    );
  }

  Widget buildLoader() {
    if (!hasMoreData) {
      return Container();
    }

    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
