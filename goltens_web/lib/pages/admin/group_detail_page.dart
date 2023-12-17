// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_core/utils/csv_generator.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';

class GroupDetailPage extends StatefulWidget {
  final int? groupId;

  const GroupDetailPage({
    super.key,
    this.groupId,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  List<GetUsersResponseData> searchMembers = [];
  List<int> selectedRows = [];
  List<int> selectedRowsToAdd = [];
  GetGroupResponseData? group;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final res = await fetchGroup(widget.groupId ?? 0);

      setState(() {
        group = res?.data;
      });
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

  Future<GetUsersResponse?> searchUsersNotInGroup(
    String search,
  ) async {
    try {
      var res = await AdminService.searchUsersNotInGroup(
        groupId: widget.groupId ?? 0,
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

  Future<void> exportCsvFile() async {
    String csvData = CSVGenerator.generateGroupMembersList(
      group?.name ?? '',
      group?.members ?? [],
    );

    const encoder = Utf8Encoder();
    final bytes = encoder.convert(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", '${group?.name}-members-list.csv')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  void addMember() {
    setState(() => selectedRows = []);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(25),
          title: const Center(child: Text("Add Members")),
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
                height: 250,
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

                              var users = await searchUsersNotInGroup(
                                searchTextController.text,
                              );

                              if (users != null) {
                                setState(() {
                                  selectedRowsToAdd = [];
                                  searchMembers = users.data;
                                });
                              }
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      searchMembers.isNotEmpty
                          ? ScrollableDataTable(
                              child: DataTable(
                                showCheckboxColumn: true,
                                columns: const <DataColumn>[
                                  DataColumn(label: Text('Avatar')),
                                  DataColumn(label: Text('Name')),
                                  DataColumn(label: Text('Email')),
                                  DataColumn(label: Text('Phone')),
                                  DataColumn(label: Text('Department')),
                                  DataColumn(label: Text('Type')),
                                ],
                                rows: searchMembers
                                    .map(
                                      (user) => DataRow(
                                        cells: <DataCell>[
                                          DataCell(
                                            CircleAvatar(
                                              radius: 16,
                                              child: user.avatar?.isNotEmpty ==
                                                      true
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        100.0,
                                                      ),
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
                                          ),
                                          DataCell(Text(user.name)),
                                          DataCell(Text(user.email)),
                                          DataCell(Text(user.phone)),
                                          DataCell(Text(user.department)),
                                          DataCell(Text(user.type.name)),
                                        ],
                                        selected: selectedRowsToAdd.contains(
                                          user.id,
                                        ),
                                        onSelectChanged: (isItemSelected) {
                                          setState(() {
                                            if (isItemSelected == true) {
                                              selectedRowsToAdd.add(
                                                user.id,
                                              );
                                            } else {
                                              selectedRowsToAdd.remove(
                                                user.id,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                        ),
                        onPressed: searchMembers.isNotEmpty
                            ? () {
                                Navigator.pop(context);
                                addMembersToGroup();
                              }
                            : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group_add),
                            SizedBox(width: 5.0),
                            Text('Add Members')
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

  void addMembersToGroup() async {
    try {
      await AdminService.addGroupMembers(
        groupId: group?.id ?? 0,
        memberIds: selectedRowsToAdd,
      );

      if (mounted) {
        const snackBar = SnackBar(content: Text('Members Added'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      final newGroupData = await fetchGroup(group?.id ?? 0);

      setState(() {
        selectedRows = [];
        searchMembers = [];

        if (newGroupData != null) {
          group?.members = newGroupData.data.members;
        }
      });
    }
  }

  void makeSubAdminsAsMembers() async {
    try {
      await AdminService.makeSubAdminsAsGroupMembers(
        groupId: group?.id ?? 0,
        subAdminIds: selectedRows,
      );

      if (mounted) {
        const snackBar = SnackBar(content: Text('Members Updated'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      setState(() => selectedRows = []);
    }
  }

  void makeMembersAsSubAdmins() async {
    try {
      await AdminService.makeGroupMembersAsSubAdmins(
        groupId: group?.id ?? 0,
        memberIds: selectedRows,
      );

      if (mounted) {
        const snackBar = SnackBar(content: Text('Members Updated'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      setState(() => selectedRows = []);
    }
  }

  void deleteMembers() async {
    try {
      await AdminService.removeGroupMembers(
        groupId: group?.id ?? 0,
        memberIds: selectedRows,
      );

      if (mounted) {
        const snackBar = SnackBar(content: Text('Members Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      final newGroupData = await fetchGroup(group?.id ?? 0);

      setState(() {
        selectedRows = [];
        searchMembers = [];

        if (newGroupData != null) {
          group?.members = newGroupData.data.members;
        }
      });
    }
  }

  Widget buildGroupDetailBody() {
    var isMobile = MediaQuery.of(context).size.width < 600;

    if (group?.members.isEmpty == true) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Members Available',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: isMobile
              ? MediaQuery.of(context).size.height / 3
              : MediaQuery.of(context).size.height / 1.5,
          child: ScrollableDataTable(
            child: DataTable(
              showCheckboxColumn: true,
              columns: const <DataColumn>[
                DataColumn(label: Text('Avatar')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Type')),
              ],
              rows: group?.members
                      .map(
                        (user) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              CircleAvatar(
                                radius: 16,
                                child: user.avatar?.isNotEmpty == true
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
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
                            ),
                            DataCell(Text(user.name)),
                            DataCell(Text(user.email)),
                            DataCell(Text(user.phone)),
                            DataCell(Text(user.department)),
                            DataCell(Text(user.type.name)),
                          ],
                          selected: selectedRows.contains(user.id),
                          onSelectChanged: (isItemSelected) {
                            setState(() {
                              if (isItemSelected == true) {
                                selectedRows.add(user.id);
                              } else {
                                selectedRows.remove(user.id);
                              }
                            });
                          },
                        ),
                      )
                      .toList() ??
                  [],
            ),
          ),
        ),
      ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: selectedRows.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 20.0 : 32.0,
                horizontal: isMobile ? 16.0 : 50.0,
              ),
              child: isMobile
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: makeSubAdminsAsMembers,
                          child: const Row(
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make Members')
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: makeMembersAsSubAdmins,
                          child: const Row(
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make SubAdmin')
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: deleteMembers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5),
                              Text('Remove Members')
                            ],
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: makeSubAdminsAsMembers,
                          child: const Row(
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make Members')
                            ],
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: makeMembersAsSubAdmins,
                          child: const Row(
                            children: [
                              Icon(Icons.manage_accounts),
                              SizedBox(width: 5),
                              Text('Make SubAdmin')
                            ],
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: deleteMembers,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5),
                              Text('Remove Members')
                            ],
                          ),
                        )
                      ],
                    ),
            )
          : Container(),
      body: Row(
        children: [
          if (!isMobile) const AdminDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isMobile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: () => Navigator.pop(context),
                                  splashRadius: 20.0,
                                ),
                                Text(
                                  group?.name ?? '',
                                  style: const TextStyle(fontSize: 28.0),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 155.0,
                              child: ElevatedButton(
                                onPressed: exportCsvFile,
                                child: ElevatedButton.icon(
                                  onPressed: exportCsvFile,
                                  icon: const Icon(Icons.table_rows_sharp),
                                  label: const Text('Export CSV'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 155.0,
                              child: ElevatedButton.icon(
                                onPressed: addMember,
                                icon: const Icon(Icons.group_add),
                                label: const Text('Add Members'),
                              ),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: () => Navigator.pop(context),
                                  splashRadius: 20.0,
                                ),
                                Text(
                                  group?.name ?? '',
                                  style: const TextStyle(fontSize: 32.0),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed: exportCsvFile,
                                  icon: const Icon(Icons.table_rows_sharp),
                                  label: const Text('Export CSV'),
                                ),
                                const SizedBox(width: 20),
                                ElevatedButton.icon(
                                  onPressed: addMember,
                                  icon: const Icon(Icons.group_add),
                                  label: const Text('Add Members'),
                                ),
                              ],
                            )
                          ],
                        ),
                  buildGroupDetailBody(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
