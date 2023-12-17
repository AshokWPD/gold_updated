import 'package:flutter/material.dart';
import 'package:goltens_core/models/feedback.dart';
import 'package:goltens_web/components/feedback/feedback_drawer.dart';
import 'package:goltens_core/services/feedback.dart';
import 'package:goltens_web/routes/routes.dart';

class UserFeedbackDashboardPage extends StatefulWidget {
  const UserFeedbackDashboardPage({super.key});

  @override
  State<UserFeedbackDashboardPage> createState() =>
      _UserFeedbackDashboardPageState();
}

class _UserFeedbackDashboardPageState extends State<UserFeedbackDashboardPage> {
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
      var res = await FeedbackService.getFeedbackDashboardData();

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

  void openFeedbackList(String filter) {
    navigateTo(
      routeName: '/feedback-list',
      queryParams: {'filter': filter},
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 500;
    var isTablet = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: const Text('Feedback App'),
      )
          : null,
      drawer: isMobile ? const FeedbackDrawer() : const SizedBox(),
      body: Row(
        children: [
          if (!isMobile) const FeedbackDrawer(),
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
                          Text(
                            'Dashboard',
                            style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  ];
                },
                body: RefreshIndicator(
                  onRefresh: fetchDashboardData,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisCount: isMobile
                              ? 1
                              : isTablet
                                  ? 2
                                  : 3,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: isMobile
                              ? 1.3
                              : isTablet
                                  ? 0.9
                                  : 1.4,
                          children: [
                            Card(
                              child: InkWell(
                                onTap: () => openFeedbackList('all'),
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
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.feedback,
                                          size: 48.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Total Feedbacks',
                                          style: TextStyle(fontSize: 18.0),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          dashboardData?.totalFeedbacks
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
                                onTap: () => openFeedbackList('green'),
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
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.feedback,
                                          size: 48.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Green Feedbacks',
                                          style: TextStyle(fontSize: 18.0),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          dashboardData?.greenFeedbacks
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
                                onTap: () => openFeedbackList('yellow'),
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
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.feedback,
                                          size: 48.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Yellow Feedbacks',
                                          style: TextStyle(fontSize: 18.0),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          dashboardData?.yellowFeedbacks
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
                                onTap: () => openFeedbackList('red'),
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
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.feedback,
                                          size: 48.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const Text(
                                          'Red Feedbacks',
                                          style: TextStyle(fontSize: 18.0),
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          dashboardData?.redFeedbacks
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
