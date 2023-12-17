// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_web/components/chat_text_field.dart';
import 'package:goltens_core/utils/csv_generator.dart';
import 'package:goltens_core/utils/pdf_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_web/routes/routes.dart';
import 'package:printing/printing.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();
  String filter = 'unread';
  List<ReadStatusUser> readUsers = [];
  List<ReadStatusUser> unReadUsers = [];
  int groupCurrentPage = 1;
  int groupTotalPages = 1;
  bool isLoading = false;
  bool isError = false;
  int limit = 50;
  String? groupSearch;
  int messageCurrentPage = 1;
  int messageTotalPages = 1;
  String? messageSearch;
  List<GetGroupsResponseData> groups = [];
  List<Map<String, dynamic>> filesArr = [];

  GetMessagesResponseData? selectedMessage;
  List<GetMessagesResponseData> messages = [];
  List<GetUsersResponseData> searchMembers = [];
  List<String> selectedRowsToAdd = [];
  List<String> selectedGroups = [];

  List<GetGroupSearchResponseData> searchedGroups = [];
  List<int> selectedGroupsToMessage = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(tabListener);
    fetchGroups();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> fetchGroups() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getGroups(
        page: groupCurrentPage,
        limit: limit,
        search: groupSearch,
      );

      setState(() {
        groups = res.data;
        isError = false;
        isLoading = false;
        groupTotalPages = res.totalPages;
      });
    } catch (err) {
      setState(() {
        isError = true;
        isLoading = false;
      });
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
  }

  Future<void> fetchMessages(int groupId) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getMessagesOfGroup(
        groupId: groupId,
        page: messageCurrentPage,
        limit: limit,
        search: messageSearch,
      );

      setState(() {
        isError = false;
        isLoading = false;
        messages = res.data;
        messageTotalPages = res.totalPages;
      });
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      setState(() {
        isError = true;
        isLoading = false;
        messages = [];
      });
    }
  }

  void groupNext() {
    if (groupCurrentPage < groupTotalPages) {
      setState(() => groupCurrentPage++);
      fetchGroups();
    }
  }

  void groupPrev() {
    if (groupCurrentPage > 1) {
      setState(() => groupCurrentPage--);
      fetchGroups();
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

  Future<GetGroupSearchResponse?> searchGroups(
    String search,
  ) async {
    try {
      var res = await AdminService.searchGroups(
        searchTerm: search,
      );

      return res;
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return null;
    }
  }

  void selectGroupsToSend(
    String title,
    String message,
    int timer,
    List<Map<String, dynamic>> filesArr,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Select Groups To Message")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var searchTextController = TextEditingController();

              return SizedBox(
                height: 400,
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                              if (searchTextController.text.isEmpty) {
                                const snackBar = SnackBar(
                                  content: Text(
                                    'Enter something to search for...,',
                                  ),
                                );

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar,
                                  );
                                }

                                return;
                              }

                              var groups = await searchGroups(
                                searchTextController.text,
                              );

                              if (groups != null) {
                                setState(() {
                                  searchedGroups = groups.data;
                                });
                              }
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      searchedGroups.isNotEmpty
                          ? SizedBox(
                              height: 200,
                              child: ScrollableDataTable(
                                child: DataTable(
                                  showCheckboxColumn: true,
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text('Avatar')),
                                    DataColumn(label: Text('Name')),
                                  ],
                                  rows: searchedGroups
                                      .map(
                                        (group) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              CircleAvatar(
                                                radius: 16,
                                                child: group.avatar
                                                            .isNotEmpty ==
                                                        true
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          100.0,
                                                        ),
                                                        child: Image.network(
                                                          '$apiUrl/$groupsAvatar/${group.avatar}',
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
                                                    : Text(group.name[0]),
                                              ),
                                            ),
                                            DataCell(Text(group.name)),
                                          ],
                                          selected:
                                              selectedGroupsToMessage.contains(
                                            group.id,
                                          ),
                                          onSelectChanged: (isItemSelected) {
                                            setState(() {
                                              if (isItemSelected == true) {
                                                selectedGroupsToMessage
                                                    .add(group.id);
                                              } else {
                                                selectedGroupsToMessage
                                                    .remove(group.id);
                                              }
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: searchedGroups.isNotEmpty
                            ? () {
                                Navigator.pop(context);
                                sendMessage(title, message, timer, filesArr);
                              }
                            : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 5.0),
                            Text('Send Message')
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

  void sendMessage(
    String title,
    String content,
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

    try {
      await AdminService.createMessage(
        selectedGroupsToMessage,
        title,
        content,
        timer,
        filesArr,
      );

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        const snackBar = SnackBar(content: Text('Message Created'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    } finally {
      setState(() {
        filesArr = [];
        searchedGroups = [];
        selectedGroupsToMessage = [];
      });
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

  void showGroupSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Search Groups")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var searchTextController = TextEditingController(
                text: groupSearch,
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
                                groupSearch = null;
                                groupCurrentPage = 1;
                              });

                              await fetchGroups();

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
                            groupSearch = searchTextController.text;
                            groupCurrentPage = 1;
                          });

                          await fetchGroups();

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Search Groups')
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

  Future<void> openGroup(GetGroupsResponseData group) async {
    navigateTo(
      routeName: '/admin/messages-detail',
      queryParams: {'group_id': group.id},
    );

    await fetchMessages(group.id);
  }

  Widget buildBody() {
    var isMobile = MediaQuery.of(context).size.width < 600;

    if (groups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Groups Available',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - (isMobile ? 150 : 108),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15),
          SizedBox(
            height: isMobile
                ? MediaQuery.of(context).size.height / 3
                : MediaQuery.of(context).size.height / 1.6,
            child: ScrollableDataTable(
              child: DataTable(
                showCheckboxColumn: false,
                columns: const <DataColumn>[
                  DataColumn(label: Text('Avatar')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Members')),
                  DataColumn(label: Text('Created At')),
                  DataColumn(label: Text('View')),
                ],
                rows: groups.map((group) {
                  var createdAt = formatDateTime(
                    group.createdAt,
                    'HH:mm dd/MM/y',
                  );

                  return DataRow(
                    onSelectChanged: (bool? selected) {
                      if (selected == true) {
                        openGroup(group);
                      }
                    },
                    cells: <DataCell>[
                      DataCell(
                        CircleAvatar(
                          radius: 16,
                          child: group.avatar?.isNotEmpty == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    '$apiUrl/$groupsAvatar/${group.avatar}',
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
                              : Text(group.name[0]),
                        ),
                      ),
                      DataCell(Text(group.name)),
                      DataCell(Text(group.members.length.toString())),
                      DataCell(Text(createdAt)),
                      DataCell(
                        IconButton(
                          onPressed: () => openGroup(group),
                          icon: const Icon(Icons.arrow_right_outlined),
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: groupCurrentPage == 1 ? null : groupPrev,
                splashRadius: 15.0,
              ),
              Text(
                '${groupTotalPages == 0 ? 0 : groupCurrentPage} / $groupTotalPages',
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed:
                    groupCurrentPage == groupTotalPages ? null : groupNext,
                splashRadius: 15.0,
              ),
            ],
          ),
        ],
      ),
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
                bottom: 0.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: isLoading
                      ? [const CircularProgressIndicator()]
                      : [
                          isMobile
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      groupSearch?.isNotEmpty == true
                                          ? 'Results for "$groupSearch"'
                                          : 'Messages',
                                      style: const TextStyle(fontSize: 28.0),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: showGroupSearchDialog,
                                      child: const SizedBox(
                                        width: 80,
                                        child: Row(
                                          children: [
                                            Icon(Icons.search),
                                            SizedBox(width: 5),
                                            Text('Search')
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      groupSearch?.isNotEmpty == true
                                          ? 'Results for "$groupSearch"'
                                          : 'Messages',
                                      style: const TextStyle(fontSize: 32.0),
                                    ),
                                    const SizedBox(width: 30),
                                    ElevatedButton(
                                      onPressed: showGroupSearchDialog,
                                      child: const Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(width: 5),
                                          Text('Search')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                          Stack(
                            children: [
                              buildBody(),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 0.0 : 4.0,
                                  ),
                                  child: Visibility(
                                    visible: !isLoading && groups.isNotEmpty,
                                    child: ChatTextField(
                                      onMessageSend: selectGroupsToSend,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
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
