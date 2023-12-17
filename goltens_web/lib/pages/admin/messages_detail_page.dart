import 'package:file_picker/file_picker.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_web/components/chat_text_field.dart';
import 'package:goltens_core/components/message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_web/routes/routes.dart';

class MessagesDetailPage extends StatefulWidget {
  final int? groupId;

  const MessagesDetailPage({super.key, this.groupId});

  @override
  State<MessagesDetailPage> createState() => _MessagesDetailPageState();
}

class _MessagesDetailPageState extends State<MessagesDetailPage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  String filter = 'unread';
  GetGroupResponseData? group;
  bool isLoading = false;
  bool isError = false;
  int limit = 50;
  int messageCurrentPage = 1;
  int totalPages = 1;
  String? messageSearch;
  bool hasMoreData = true;
  List<Map<String, dynamic>> filesArr = [];

  List<GetMessagesResponseData> messages = [];
  GetMessageResponseData? messageDetail;
  List<GetUsersResponseData> searchMembers = [];
  List<String> selectedRowsToAdd = [];

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final groupDetail = await fetchGroup(widget.groupId ?? 0);
      setState(() => group = groupDetail?.data);
      fetchMessages(group?.id ?? 0, true);
    });
  }

  Future<GetGroupResponse?> fetchGroup(int groupId) async {
    try {
      final res = AdminService.getGroup(id: groupId);
      return res;
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
  }

  void scrollListener() {
    bool outOfRange = scrollController.position.outOfRange;
    double offset = scrollController.offset;

    if (offset >= scrollController.position.maxScrollExtent && !outOfRange) {
      fetchMessages(group?.id ?? 0, false);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }

  Future<void> fetchMessages(int groupId, bool refresh) async {
    if (refresh) {
      if (isLoading) return;

      setState(() {
        isLoading = true;
        messageCurrentPage = 1;
        messages = [];
      });
    } else {
      if (isLoading || !hasMoreData) return;

      setState(() {
        isLoading = true;
      });
    }

    try {
      var getMessagesResponse = await AdminService.getMessagesOfGroup(
        groupId: groupId,
        page: messageCurrentPage,
        limit: limit,
        search: messageSearch,
      );

      setState(() {
        messages.addAll(getMessagesResponse.data);
        isLoading = false;
        hasMoreData = getMessagesResponse.data.length == limit;
        messageCurrentPage++;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void sendMessage(
    String title,
    String content,
    int timer,
    List<Map<String, dynamic>> filesArr,
  ) async {
    try {
      await AdminService.createMessage(
        [group?.id ?? 0],
        title,
        content,
        timer,
        filesArr,
      );

      if (mounted) {
        const snackBar = SnackBar(content: Text('Message Created'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      await fetchMessages(group?.id ?? 0, true);
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      setState(() {
        filesArr = [];
      });
    }
  }

  Future<void> pickFiles(FileType fileType, StateSetter setState) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowMultiple: true,
      );

      if (result != null) {
        List<PlatformFile> files = result.files.map((file) => file).toList();

        for (var file in files) {
          setState(() {
            filesArr.add({'file': file, 'type': fileType});
          });
        }

        if (mounted) {
          final snackBar = SnackBar(
            content: Text('${files.length} Files Added'),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Widget buildLoader() {
    if (!isLoading) {
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

  Widget buildMessageList() {
    if (isLoading && messages.isEmpty) {
      return buildLoader();
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

    return SizedBox(
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
          var time = formatDateTime(message.createdAt, 'HH:mm dd/MM/y');

          var messageId = formatDateTime(
            message.createdAt,
            'yyMM\'SN${message.id}\'',
          );

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

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 0.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 550),
              child: MessageCard(
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
                showPadding: false,
                onTap: () async {
                  navigateTo(
                    routeName: '/admin/message-detail',
                    queryParams: {
                      'message_id': message.id,
                      'group_id': group?.id,
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void createMessage() {
    showDialog(
      context: context,
      builder: (context) {
        var formKey = GlobalKey<FormState>();
        var titleTextController = TextEditingController();
        var contentTextController = TextEditingController();
        var timerTextController = TextEditingController();

        return AlertDialog(
          title: const Center(child: Text("Create Message")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 275,
                width: 410,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: contentTextController,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Content',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter content';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                ),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                labelText: 'Time in (Seconds)',
                                helperText:
                                    'Time for user to read this message',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              controller: timerTextController,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter valid second';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Column(
                        children: filesArr.map((fileObj) {
                          var icon = Icons.insert_drive_file;

                          switch (fileObj['type']) {
                            case FileType.image:
                              icon = Icons.photo;
                              break;
                            case FileType.video:
                              icon = Icons.video_camera_back_rounded;
                              break;
                            case FileType.audio:
                              icon = Icons.headset;
                              break;
                            default:
                          }

                          return ListTile(
                            leading: Icon(icon),
                            title: Text(
                              '${fileObj['file'].name}',
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                filesArr.removeWhere(
                                  (elem) =>
                                      elem['file'].name == fileObj['file'].name,
                                );

                                setState(() => filesArr = filesArr);
                              },
                              icon: const Icon(Icons.close),
                            ),
                            onTap: () {},
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo),
                        label: const Text('Add Image'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        onPressed: () async {
                          pickFiles(FileType.image, setState);
                        },
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.video_camera_back_rounded),
                        label: const Text('Add Video'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        onPressed: () async {
                          setState(() {
                            pickFiles(FileType.video, setState);
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.headset),
                        label: const Text('Add Audio'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        onPressed: () async {
                          setState(() {
                            pickFiles(FileType.audio, setState);
                          });
                        },
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.file_copy),
                        label: const Text('Add Document'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        onPressed: () async {
                          setState(() {
                            pickFiles(FileType.any, setState);
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Send Message'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);

                            sendMessage(
                              titleTextController.text,
                              contentTextController.text,
                              int.parse(timerTextController.text),
                              filesArr,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showMessageSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Search Messages")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var searchTextController = TextEditingController(
                text: messageSearch,
              );

              return SizedBox(
                height: 150,
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: searchTextController,
                        decoration: InputDecoration(
                          labelText: 'Search...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              setState(() {
                                messageSearch = null;
                                messageCurrentPage = 1;
                              });

                              await fetchMessages(group?.id ?? 0, true);

                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (searchTextController.text.isEmpty) {
                            const snackBar = SnackBar(
                              content: Text(
                                'Enter something to search for...,',
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );

                            return;
                          }

                          setState(() {
                            messageSearch = searchTextController.text;
                            messageCurrentPage = 1;
                          });

                          await fetchMessages(group?.id ?? 0, true);

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Search Messages')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: Text('Admin Page'),
      )
          : null,
      drawer: isMobile ? AdminDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) const AdminDrawer(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: isMobile ? 16.0 : 32.0,
                left: isMobile ? 16.0 : 32.0,
                right: isMobile ? 16.0 : 32.0,
              ),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          isMobile
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                          ),
                                          onPressed: () => Navigator.pop(
                                            context,
                                          ),
                                          splashRadius: 20.0,
                                        ),
                                        Text(
                                          messageSearch?.isNotEmpty == true
                                              ? 'Results for "$messageSearch"'
                                              : group!.name,
                                          style:
                                              const TextStyle(fontSize: 28.0),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: 120.0,
                                      child: ElevatedButton(
                                        onPressed: showMessageSearchDialog,
                                        child: const Row(
                                          children: [
                                            Icon(Icons.search),
                                            SizedBox(width: 5.0),
                                            Text('Search')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                          ),
                                          onPressed: () => Navigator.pop(
                                            context,
                                          ),
                                          splashRadius: 20.0,
                                        ),
                                        Text(
                                          messageSearch?.isNotEmpty == true
                                              ? 'Results for "$messageSearch"'
                                              : group?.name ?? '---',
                                          style:
                                              const TextStyle(fontSize: 32.0),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: showMessageSearchDialog,
                                      child: const Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(width: 5.0),
                                          Text('Search')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ];
                },
                body: Stack(
                  children: [
                    buildMessageList(),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 40.0,
                        ),
                        child: ChatTextField(
                          onMessageSend: sendMessage,
                        ),
                      ),
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
}
