import 'package:flutter/material.dart';
import 'package:goltens_web/components/admin/feedback/admin_feedback_drawer.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_web/routes/routes.dart';

class FeedbackDashboardPage extends StatefulWidget {
  const FeedbackDashboardPage({super.key});

  @override
  State<FeedbackDashboardPage> createState() => _FeedbackDashboardPageState();
}

class _FeedbackDashboardPageState extends State<FeedbackDashboardPage> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  bool isLoading = false;
  bool isError = false;
  String? search;
  FeedbackDashboardData? dashboardData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchDashboardData();
    });
  }

  Future<void> fetchDashboardData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getFeedbackDashboardData();

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

  void openFeedbackList(String color, String status) {
    navigateTo(
      routeName: '/admin/feedbacks',
      queryParams: {'color': color, 'status': status},
    );
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
      drawer: isMobile ? AdminFeedbackDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) const AdminFeedbackDrawer(),
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
                                  onTap: () => openFeedbackList('all', 'all'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.feedback,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Total Feedbacks',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.totalFeedback
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () => openFeedbackList('red', 'all'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.feedback,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Red Feedbacks',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.redFeedback
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () =>
                                      openFeedbackList('yellow', 'all'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.feedback,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Yellow Feedbacks',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.yellowFeedback
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () => openFeedbackList('green', 'all'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.feedback,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Green Feedbacks',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.greenFeedback
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () =>
                                      openFeedbackList('all', 'inProgress'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.refresh_outlined,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'In Progress',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.inProgress
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () =>
                                      openFeedbackList('all', 'rejected'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Rejected',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.rejected
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () =>
                                      openFeedbackList('all', 'closed'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.done,
                                            size: 52.0,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          const Text(
                                            'Closed',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.closed.toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () => openFeedbackList(
                                      'all', 'closedWithoutAction'),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
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
                                            'Closed Without Action',
                                            style: TextStyle(fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            dashboardData?.closedWithoutAction
                                                    .toString() ??
                                                '-',
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
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
