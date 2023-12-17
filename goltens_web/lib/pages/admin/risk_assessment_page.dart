// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_web/routes/routes.dart';

class RiskAssessmentPage extends StatefulWidget {
  const RiskAssessmentPage({super.key});

  @override
  State<RiskAssessmentPage> createState() => _RiskAssessmentPageState();
}

class _RiskAssessmentPageState extends State<RiskAssessmentPage> {
  int currentPage = 1;
  int totalPages = 1;
  String? search;
  List<GetGroupsResponseData> groups = [];
  int limit = 50;
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getGroups(
        page: currentPage,
        limit: limit,
        search: search,
      );

      setState(() {
        groups = res.data;
        isError = false;
        isLoading = false;
        totalPages = res.totalPages;
      });
    } catch (err) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
      fetchGroups();
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      fetchGroups();
    }
  }

  void showSearchDialog() {
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
                text: search,
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
                                search = null;
                                currentPage = 1;
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
                            search = searchTextController.text;
                            currentPage = 1;
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
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: isMobile
              ? MediaQuery.of(context).size.height / 3
              : MediaQuery.of(context).size.height / 1.5,
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
                var createdAt =
                    formatDateTime(group.createdAt, 'HH:mm dd/MM/y');

                return DataRow(
                  onSelectChanged: (bool? selected) async {
                    navigateTo(
                      routeName: '/admin/risk-assessment-detail',
                      queryParams: {'group_id': group.id},
                    );
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
                        onPressed: () async {
                          navigateTo(
                            routeName: '/admin/risk-assessment-detail',
                            queryParams: {'group_id': group.id},
                          );
                        },
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
              onPressed: currentPage == 1 ? null : prevPage,
              splashRadius: 15.0,
            ),
            Text(
              '${totalPages == 0 ? 0 : currentPage} / $totalPages',
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: currentPage == totalPages ? null : nextPage,
              splashRadius: 15.0,
            ),
          ],
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
      body: Row(
        children: [
          if (!isMobile) const AdminDrawer(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
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
                                    search?.isNotEmpty == true
                                        ? 'Results for "$search"'
                                        : 'Risk Assessment',
                                    style: const TextStyle(fontSize: 28.0),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    search?.isNotEmpty == true
                                        ? 'Results for "$search"'
                                        : 'Risk Assessment',
                                    style: const TextStyle(fontSize: 32.0),
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: showSearchDialog,
                                        child: const Row(
                                          children: [
                                            Icon(Icons.search),
                                            SizedBox(width: 5),
                                            Text('Search')
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        buildBody(),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
