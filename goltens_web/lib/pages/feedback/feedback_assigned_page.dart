import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:goltens_core/models/feedback.dart';
import 'package:goltens_web/components/feedback/feedback_drawer.dart';
import 'package:goltens_web/pages/feedback/feedback_page.dart';
import 'package:goltens_web/provider/global_state.dart';
import 'package:goltens_core/services/feedback.dart';
import 'package:provider/provider.dart';

class FeedbackAssignedPage extends StatefulWidget {
  const FeedbackAssignedPage({super.key});

  @override
  State<FeedbackAssignedPage> createState() => _FeedbackAssignedPageState();
}

class _FeedbackAssignedPageState extends State<FeedbackAssignedPage> {
  int page = 1;
  int totalPages = 1;
  int limit = 50;
  bool isLoading = false;
  bool isError = false;
  String? search;
  List<FeedbackData> feedbacks = [];
  bool hasMoreData = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAssignedFeedbacks(false);
    });
  }

  void scrollListener() {
    bool outOfRange = scrollController.position.outOfRange;
    double offset = scrollController.offset;

    if (offset >= scrollController.position.maxScrollExtent && outOfRange) {
      fetchAssignedFeedbacks(false);
    }
  }

  Future<void> fetchAssignedFeedbacks(bool refresh) async {
    if (!refresh) {
      if (isLoading || !hasMoreData) return;
    } else {
      if (isLoading) return;

      setState(() {
        page = 1;
        feedbacks = [];
      });
    }

    setState(() {
      isLoading = true;
    });

    try {
      var res = await FeedbackService.getAssignedFeedbacks(
        page: page,
        limit: limit,
      );

      setState(() {
        feedbacks.addAll(res.data);
        isError = false;
        isLoading = false;
        hasMoreData = feedbacks.length == limit;
        page += 1;
      });
    } catch (err) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  Widget buildBody() {
    if (isLoading && feedbacks.isEmpty) {
      return buildLoader();
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
              onPressed: () => fetchAssignedFeedbacks(true),
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

    if (feedbacks.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Feedbacks Available',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => fetchAssignedFeedbacks(true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        itemCount: feedbacks.length + 1,
        itemBuilder: (context, index) {
          if (index == feedbacks.length) {
            return buildLoader();
          } else {
            return buildFeedbackListItem(feedbacks[index]);
          }
        },
      ),
    );
  }

  Widget buildFeedbackListItem(FeedbackData feedback) {
    var user = context.read<GlobalState>().user?.data;

    var feedbackAssignment = feedback.feedbackAssignments.firstWhereOrNull(
      (el) => el.userId == user?.id && el.feedbackId == feedback.id,
    );

    return ListTile(
      title: Text(
        'Feedback - FB${feedback.id} on ${feedback.date} ${feedback.time}',
      ),
      subtitle: Text(
        feedback.description,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.all(0),
      trailing: feedbackAssignment?.assignmentCompleted == true
          ? const Icon(Icons.done, color: Colors.green)
          : null,
      onTap: () {
        // Leaving this navigation type as it is
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FeedbackPage(),
            settings: RouteSettings(arguments: feedback),
          ),
        );
      },
    );
  }

  Widget buildLoader() {
    if (!hasMoreData) {
      return Container();
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
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
        title: Text('Feedback App'),
      )
          : null,
      drawer: isMobile ? FeedbackDrawer() : null,
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
                            'Assigned Feedbacks',
                            style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  ];
                },
                body: RefreshIndicator(
                  onRefresh: () => fetchAssignedFeedbacks(true),
                  child: buildBody(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
