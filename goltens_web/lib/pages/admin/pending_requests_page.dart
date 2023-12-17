import 'package:flutter/material.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  bool isLoading = false;
  bool isError = false;
  String? search;
  List<GetUsersResponseData> pendingRequests = [];

  @override
  void initState() {
    super.initState();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getPendingRequests(
        page: currentPage,
        limit: limit,
        search: search,
      );

      setState(() {
        pendingRequests = res.data;
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
      fetchPendingRequests();
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      fetchPendingRequests();
    }
  }

  void updateAdminApproved(
    GetUsersResponseData user,
    AdminApproved adminApproved,
  ) async {
    try {
      await AdminService.updateAdminApproved(
        id: user.id,
        adminApproved: adminApproved,
      );

      fetchPendingRequests();

      if (mounted) {
        final snackBar = SnackBar(
          content: Text(
            adminApproved == AdminApproved.approved
                ? 'Request Accepted'
                : 'Request Rejected',
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Search Pending Requests")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var searchTextController = TextEditingController(text: search);

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

                              await fetchPendingRequests();

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

                          await fetchPendingRequests();

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Search Pending Requests')
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

    if (pendingRequests.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Pending Requests Available',
                style: TextStyle(fontSize: 16.0),
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
              columns: const <DataColumn>[
                DataColumn(label: Text('Avatar')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Department')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Accept')),
                DataColumn(label: Text('Reject')),
              ],
              rows: pendingRequests
                  .map(
                    (user) => DataRow(
                      cells: <DataCell>[
                        DataCell(
                          CircleAvatar(
                            radius: 16,
                            child: user.avatar?.isNotEmpty == true
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
                        ),
                        DataCell(Text(user.name)),
                        DataCell(Text(user.email)),
                        DataCell(Text(user.phone)),
                        DataCell(Text(user.department)),
                        DataCell(Text(user.type.name)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.done),
                            color: Theme.of(context).primaryColor,
                            onPressed: () => updateAdminApproved(
                              user,
                              AdminApproved.approved,
                            ),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            onPressed: () => updateAdminApproved(
                              user,
                              AdminApproved.rejected,
                            ),
                            color: Colors.redAccent,
                            icon: const Icon(Icons.block),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
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
            Text('${totalPages == 0 ? 0 : currentPage} / $totalPages'),
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
                                        : 'Pending Requests',
                                    style: const TextStyle(fontSize: 28.0),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: showSearchDialog,
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
                                    search?.isNotEmpty == true
                                        ? 'Results for "$search"'
                                        : 'Pending Requests',
                                    style: const TextStyle(fontSize: 32.0),
                                  ),
                                  const SizedBox(width: 30),
                                  ElevatedButton(
                                    onPressed: showSearchDialog,
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
