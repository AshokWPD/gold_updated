import 'package:flutter/material.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_web/routes/routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  bool isLoading = false;
  bool isError = false;
  String? search;
  DashboardResponseData? dashboardData;

  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  Future<void> getDashboardData() async {
    if (isLoading || !mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getDashboardData();

      setState(() {
        dashboardData = res.data;
        isError = false;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 600;
    var isTablet = MediaQuery.of(context).size.width < 800;

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
                        Text(
                          'Dashboard',
                          style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: isMobile
                                ? 1
                                : isTablet
                                    ? 2
                                    : 3,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            childAspectRatio: isMobile
                                ? 1.3
                                : isTablet
                                    ? 0.9
                                    : 1.4,
                            children: [
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(routeName: '/admin/users');
                                  },
                                  child: SizedBox(
                                    height: 500,
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.account_circle_rounded,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Total Users',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            dashboardData?.totalUsers
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(routeName: '/admin/subadmins');
                                  },
                                  child: SizedBox(
                                    height: 500,
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.manage_accounts,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Total SubAdmins',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            dashboardData?.totalSubAdmins
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(routeName: '/admin/groups');
                                  },
                                  child: SizedBox(
                                    height: 500,
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.group,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Total Groups',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            dashboardData?.totalGroups
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(
                                        routeName: '/admin/pending-requests');
                                  },
                                  child: SizedBox(
                                    height: 500,
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.done_all,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Pending Requests',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            dashboardData?.totalPendingRequests
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(routeName: '/admin/messages');
                                  },
                                  child: SizedBox(
                                    height: 500,
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.message,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Total Messages',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            dashboardData?.totalMessages
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(
                                        routeName: '/admin/risk-assessment');
                                  },
                                  child: SizedBox(
                                    height: 500,
                                    width: 300,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.list_alt,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Assessments',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Text(
                                            dashboardData?.totalRiskAssessments
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
