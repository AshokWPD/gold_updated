// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/risk_assessment.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_core/services/risk_assessment.dart';
import 'package:goltens_web/components/user_communication_drawer.dart';

class AssessmentDetailPage extends StatefulWidget {
  final int? groupId;
  final String? groupName;

  const AssessmentDetailPage({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<AssessmentDetailPage> createState() => _AssessmentDetailPageState();
}

class _AssessmentDetailPageState extends State<AssessmentDetailPage> {
  ScrollController assessmentsScrollController = ScrollController();
  final int limit = 50;
  int assessmentsPage = 1;
  List<GetAssessmentsResponseData> assessments = [];
  String? assessmentsSearch;
  bool isAssessmentsLoading = false;
  bool hasAssessmentsError = false;
  bool hasMoreAssessments = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchAssessments(false);
      assessmentsScrollController.addListener(assessmentsScrollListener);
    });
  }

  @override
  void dispose() {
    assessmentsScrollController.removeListener(assessmentsScrollListener);
    super.dispose();
  }

  void assessmentsScrollListener() {
    bool outOfRange = assessmentsScrollController.position.outOfRange;
    double offset = assessmentsScrollController.offset;

    if (offset >= assessmentsScrollController.position.maxScrollExtent &&
        outOfRange) {
      fetchAssessments(false);
    }
  }

  Future<void> fetchAssessments(bool refresh) async {
    if (!refresh) {
      if (isAssessmentsLoading || !hasMoreAssessments) return;
    } else {
      if (isAssessmentsLoading) return;

      setState(() {
        assessmentsPage = 1;
        assessments = [];
      });
    }

    setState(() {
      isAssessmentsLoading = true;
    });

    try {
      final response = await RiskAssessmentService.getRiskAssessmentItems(
        assessmentsPage,
        limit,
        widget.groupId ?? 0,
        assessmentsSearch,
      );

      setState(() {
        assessments.addAll(response.data);
        isAssessmentsLoading = false;
        hasMoreAssessments = assessments.length == limit;
      });
    } catch (e) {
      setState(() {
        isAssessmentsLoading = false;
        hasAssessmentsError = true;
      });
    }
  }

  Future<void> retryFetchAssessments() async {
    setState(() {
      hasAssessmentsError = false;
    });

    await fetchAssessments(true);
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 500;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
        title: Text('Communication Page'),
      )
          : null,
      drawer: isMobile ? UserCommunicationDrawer() : null,
      body: Row(
        children: [
          if (!isMobile) const UserCommunicationDrawer(),
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
                            widget.groupName ?? 'Loading...',
                            style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                  ];
                },
                body: buildAssessmentList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAssessmentList() {
    if (isAssessmentsLoading && assessments.isEmpty) {
      return buildLoader();
    }

    if (hasAssessmentsError) {
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
              onPressed: retryFetchAssessments,
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

    if (assessments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Assessments Available',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => fetchAssessments(true),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: assessmentsScrollController,
        itemCount: assessments.length,
        itemBuilder: (context, index) {
          return buildAssessmentListItem(assessments[index]);
        },
      ),
    );
  }

  Widget buildLoader() {
    if (!hasMoreAssessments) {
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

  Widget buildAssessmentListItem(
    GetAssessmentsResponseData assessment,
  ) {
    var time = formatDateTime(assessment.createdAt, 'HH:mm dd/MM/y');

    return ListTile(
      title: Text(assessment.name),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time),
        ],
      ),
      onTap: () async {
        var url = '$apiUrl/$riskAssessmentDir/${assessment.name}';
        var anchorElement = html.AnchorElement(href: url.toString());
        anchorElement.target = '_blank';
        anchorElement.click();
      },
    );
  }
}
