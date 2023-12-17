// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/utils/csv_generator.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_core/utils/pdf_generator.dart';
import 'package:goltens_core/components/message_card.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_web/utils/functions.dart';
import 'package:printing/printing.dart';

class MessageDetailPage extends StatefulWidget {
  final int? groupId;
  final int? messageId;

  const MessageDetailPage({
    super.key,
    this.groupId,
    this.messageId,
  });

  @override
  State<MessageDetailPage> createState() => _MessageDetailAdminPageState();
}

class _MessageDetailAdminPageState extends State<MessageDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  GetMessageResponseData? messageDetail;
  bool showOptions = false;
  bool isLoading = false;
  String filter = 'unread';
  int messageCurrentPage = 1;
  List<GetMessagesResponseData> messages = [];
  bool hasMoreData = true;
  int limit = 50;
  int totalPages = 1;
  String? messageSearch;
  bool isError = false;
  bool messageRead = false;
  List<ReadStatusUser> readUsers = [];
  List<ReadStatusUser> unReadUsers = [];
  List<MessageChangeData> changesData = [];
  GetMessageResponseData? selectedMessage;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(tabListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        fetchMessage(widget.messageId ?? 0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController.removeListener(tabListener);
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
  }

  Future<void> fetchMessage(int messageId) async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      var res = await AdminService.getMessage(messageId: messageId);

      setState(() {
        isLoading = false;
        messageDetail = res.data;
      });
    } catch (e) {
      if (mounted) {
        if (mounted) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteMessage(
    GetMessageResponseData message,
  ) async {
    try {
      await AdminService.deleteMessage(messageId: message.id);

      if (mounted) {
        if (mounted) {
          const snackBar = SnackBar(content: Text('Message Deleted'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void showDeleteDialog(
    GetMessageResponseData message,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure you want delete this message ?"),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                await deleteMessage(message);

                if (mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateMessage(
    int messageId,
    String title,
    String content,
    String timer,
  ) async {
    try {
      await AdminService.updateMessage(
        messageId,
        title,
        content,
        int.parse(timer),
        messageDetail?.files ?? [],
      );

      await fetchMessage(messageId);

      if (mounted) {
        const snackBar = SnackBar(content: Text('Message Updated'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Future<void> exportPdfFile() async {
    var messageId = formatDateTime(
      selectedMessage?.createdAt ?? DateTime.now(),
      'yyMM\'SN${selectedMessage?.id}\'',
    );

    var uri = Uri.parse(apiUrl);
    var logoImage = await networkImage('${uri.origin}/assets/images/logo.png');

    Uint8List pdfInBytes = await PDFGenerator.generateReadStatus(
      selectedMessage?.id ?? 0,
      selectedMessage?.content ?? '',
      selectedMessage?.createdAt ?? DateTime.now(),
      logoImage,
      readUsers,
      unReadUsers,
    );

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", 'read-status-$messageId.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> exportCsvFile() async {
    String csvData = CSVGenerator.generateReadStatus(readUsers, unReadUsers);
    const encoder = Utf8Encoder();
    final bytes = encoder.convert(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", 'read-status-${selectedMessage?.id}.csv')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> fetchReadStatus() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      var response = await AdminService.getMessageReadStatus(
        selectedMessage?.id ?? 0,
        widget.groupId ?? 0,
      );

      setState(() {
        readUsers = response.readUsers;
        unReadUsers = response.unreadUsers;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Future<void> fetchChanges() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      var response = await AdminService.getMessageChanges(
        selectedMessage?.id ?? 0,
      );

      setState(() {
        changesData = response.data;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  Widget buildLoader() {
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

  Widget buildStatusList(String itemToRender) {
    List<ReadStatusUser> users;

    if (itemToRender == 'unread') {
      users = unReadUsers;
    } else {
      users = readUsers;
    }

    if (isLoading && users.isEmpty) {
      return buildLoader();
    }

    if (isError) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
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
              onPressed: fetchReadStatus,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
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

    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index != users.length) {
          ReadStatusUser user = users[index];
          var time = '';

          if (filter == 'read' && user.readAt != null) {
            time = formatDateTime(user.readAt!, 'HH:mm dd/MM/y');
          }

          return ListTile(
            title: Text(user.name),
            leading: CircleAvatar(
              radius: 12,
              child: user.avatar.isNotEmpty == true
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Image.network(
                        '$apiUrl/$avatar/${user.avatar}',
                        fit: BoxFit.contain,
                        height: 500,
                        width: 500,
                        errorBuilder: (
                          context,
                          obj,
                          stacktrace,
                        ) {
                          return Container();
                        },
                      ),
                    )
                  : Text(user.name[0]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(time)],
            ),
          );
        }

        return null;
      },
    );
  }

  Future<void> showReadInfoDialog(
    GetMessageResponseData message,
  ) async {
    setState(() => selectedMessage = message);
    await fetchReadStatus();
    if (!mounted) return;

    var messageId = formatDateTime(
      selectedMessage?.createdAt ?? DateTime.now(),
      'yyMM\'SN${selectedMessage?.id}\'',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Read Info of "${message.content} - $messageId"'),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              return SizedBox(
                height: 380,
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TabBar(
                      controller: tabController,
                      labelColor: Theme.of(context).primaryColor,
                      tabs: const [
                        Tab(text: 'Unread'),
                        Tab(text: 'Read'),
                      ],
                      onTap: (index) => setState(() {}),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Center(child: buildStatusList('unread')),
                          Center(child: buildStatusList('read')),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: exportPdfFile,
                child: const Text('EXPORT PDF'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: exportCsvFile,
                child: const Text('EXPORT CSV'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> exportChangesPdfFile() async {
    var messageId = formatDateTime(
      selectedMessage?.createdAt ?? DateTime.now(),
      'yyMM\'SN${selectedMessage?.id}\'',
    );

    var uri = Uri.parse(apiUrl);
    var logoImage = await networkImage('${uri.origin}/assets/images/logo.png');

    // Save the PDF file
    Uint8List pdfInBytes = await PDFGenerator.generateMessageChanges(
      selectedMessage?.id ?? 0,
      selectedMessage?.content ?? '',
      logoImage,
      selectedMessage?.createdAt ?? DateTime.now(),
      changesData,
    );

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", 'message-tracking-history-$messageId.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> showChangesDialog(
    GetMessageResponseData message,
  ) async {
    setState(() => selectedMessage = message);
    await fetchChanges();
    if (!mounted) return;

    var messageId = formatDateTime(
      selectedMessage?.createdAt ?? DateTime.now(),
      'yyMM\'SN${selectedMessage?.id}\'',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tracking History of "${message.title} - $messageId"'),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              if (changesData.isEmpty) {
                return const SizedBox(
                  height: 380,
                  child: Center(
                    child: Text('No Message History'),
                  ),
                );
              }

              return SizedBox(
                height: 380,
                width: double.maxFinite,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                  itemCount: changesData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var row = changesData[index];

                    var readInfo = changesData[index].reads.map((e) {
                      var time = formatDateTime(e.readAt, 'HH:mm dd/MM/y');
                      return '${e.reply} (${e.mode}) - $time';
                    }).join('\n');

                    return ListTile(
                      title: Text('${row.name} (${row.email})'),
                      subtitle: Text(readInfo),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: exportChangesPdfFile,
                child: const Text('EXPORT PDF'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CLOSE'),
              ),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(
    GetMessageResponseData message,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text("Update Message")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var formKey = GlobalKey<FormState>();

              var titleTextController = TextEditingController(
                text: messageDetail?.title,
              );

              var contentTextController = TextEditingController(
                text: messageDetail?.content,
              );

              var timerTextController = TextEditingController(
                text: messageDetail?.timer.toString(),
              );

              return SizedBox(
                height: 340,
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
                              controller: titleTextController,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Please enter title';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
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
                        children: messageDetail?.files.map((fileObj) {
                              var icon = Icons.insert_drive_file;

                              switch (nameToFileType(fileObj.fileType)) {
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
                                  fileObj.name.split('/').last,
                                  overflow: TextOverflow.clip,
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    messageDetail?.files.removeWhere(
                                      (elem) => elem.name == fileObj.name,
                                    );

                                    setState(
                                      () => messageDetail = messageDetail,
                                    );
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                                onTap: () {},
                              );
                            }).toList() ??
                            [],
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.send),
                        label: const Text('Update Message'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);
                            updateMessage(
                              message.id,
                              titleTextController.text,
                              contentTextController.text,
                              timerTextController.text,
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

  @override
  Widget build(BuildContext context) {
    final message = messageDetail;
    var isMobile = MediaQuery.of(context).size.width < 600;

    if (message == null) {
      return Scaffold(
        body: buildLoader(),
      );
    }

    var time = formatDateTime(message.createdAt, 'HH:mm dd/MM/y');
    String? imageUrl;

    var messageId = formatDateTime(
      selectedMessage?.createdAt ?? DateTime.now(),
      'yyMM\'SN${message.id}\'',
    );

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
              padding: const EdgeInsets.all(32.0),
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
                                        Flexible(
                                          child: Text(
                                            '${message.title} - $messageId',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontSize: 28.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 130,
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              showChangesDialog(message);
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.info),
                                                SizedBox(width: 5.0),
                                                Text('Tracking History')
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              showReadInfoDialog(message);
                                            },
                                            child: const Row(
                                              children: [
                                                Icon(Icons.info),
                                                SizedBox(width: 5.0),
                                                Text('Read Info')
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () =>
                                                showEditDialog(message),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.edit),
                                                SizedBox(width: 5.0),
                                                Text('Edit')
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            onPressed: () =>
                                                showDeleteDialog(message),
                                            child: const Row(
                                              children: [
                                                Icon(Icons.delete),
                                                SizedBox(width: 5.0),
                                                Text('Delete')
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon:
                                              const Icon(Icons.arrow_back_ios),
                                          onPressed: () => Navigator.pop(
                                            context,
                                          ),
                                          splashRadius: 20.0,
                                        ),
                                        Text(
                                          '${message.title} - $messageId',
                                          style:
                                              const TextStyle(fontSize: 32.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            showChangesDialog(message);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.info),
                                              SizedBox(width: 5.0),
                                              Text('Tracking History')
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            showReadInfoDialog(message);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.info),
                                              SizedBox(width: 5.0),
                                              Text('Read Info')
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () =>
                                              showEditDialog(message),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.edit),
                                              SizedBox(width: 5.0),
                                              Text('Edit')
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        ElevatedButton(
                                          onPressed: () =>
                                              showDeleteDialog(message),
                                          child: const Row(
                                            children: [
                                              Icon(Icons.delete),
                                              SizedBox(width: 5.0),
                                              Text('Delete')
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      MessageCard(
                                        messageId: messageId,
                                        title: message.title,
                                        content: message.content,
                                        showFullContent: true,
                                        createdByAvatar:
                                            message.createdBy.avatar,
                                        createdByName: message.createdBy.name,
                                        imageUrl: imageUrl,
                                        isUnread: null,
                                        files: message.files,
                                        time: time,
                                        showPadding: false,
                                        onTap: () async {},
                                      ),
                                      const SizedBox(height: 5.0),
                                      message.files.isNotEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical: 8.0,
                                              ),
                                              child: Text(
                                                'Files',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      Column(
                                        children: messageDetail?.files
                                                .map((fileObj) {
                                              var icon =
                                                  Icons.insert_drive_file;

                                              switch (nameToFileType(
                                                  fileObj.fileType)) {
                                                case FileType.image:
                                                  icon = Icons.photo;
                                                  break;
                                                case FileType.video:
                                                  icon = Icons
                                                      .video_camera_back_rounded;
                                                  break;
                                                case FileType.audio:
                                                  icon = Icons.headset;
                                                  break;
                                                default:
                                              }

                                              return ListTile(
                                                leading: Icon(icon),
                                                title: Text(
                                                  fileObj.name.split('/').last,
                                                  overflow: TextOverflow.clip,
                                                ),
                                                onTap: () async {
                                                  var url = '$apiUrl'
                                                      '/$groupData'
                                                      '/${fileObj.name}';

                                                  html.window
                                                      .open(url, '_blank');
                                                },
                                              );
                                            }).toList() ??
                                            [],
                                      ),
                                      const SizedBox(height: 10.0),
                                      const Divider(height: 5)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: SizedBox(
                  width: 600,
                  child: buildBody(message),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBody(GetMessageResponseData message) {
    if (isLoading || messageDetail == null) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
    }

    if (isError) {
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
              onPressed: () => fetchMessage(message.id),
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
      onRefresh: () => fetchMessage(message.id),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 80.0),
        itemCount: messageDetail!.read.length,
        itemBuilder: (BuildContext context, int index) {
          var readObject = messageDetail!.read[index];
          var time = formatDateTime(readObject.readAt, 'HH:mm dd/MM/y');

          if (readObject.reply?.isNotEmpty == true) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            '${readObject.reply} (${readObject.mode})',
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              time,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              radius: 12,
                              child: readObject.user.avatar.isNotEmpty == true
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: Image.network(
                                        '$apiUrl/$avatar/${readObject.user.avatar}',
                                        fit: BoxFit.contain,
                                        height: 500,
                                        width: 500,
                                        errorBuilder: (
                                          context,
                                          obj,
                                          stacktrace,
                                        ) {
                                          return Container();
                                        },
                                      ),
                                    )
                                  : Text(
                                      readObject.user.name[0],
                                    ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              readObject.user.name,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
