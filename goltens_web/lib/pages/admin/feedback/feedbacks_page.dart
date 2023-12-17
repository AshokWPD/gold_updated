// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_web/components/admin/feedback/admin_feedback_drawer.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_web/pages/admin/feedback/feedback_detail_page.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_core/utils/csv_generator.dart';

class Feedbacks extends StatefulWidget {
  final String? color;
  final String? status;

  const Feedbacks({
    super.key,
    this.color,
    this.status,
  });

  @override
  State<Feedbacks> createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 40;
  bool isLoading = false;
  bool isError = false;
  String? color = 'all';
  String? status = 'all';
  String? search;
  List<GetFeedbacksResponseData> feedbacks = [];
  List<int> selectedFeedbacks = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        if (widget.color != 'null') {
          color = widget.color ?? 'all';
        }

        if (widget.status != 'null') {
          status = widget.status ?? 'all';
        }
      });

      fetchFeedbacks();
    });
  }

  Future<void> exportCsvFile() async {
    var res = await AdminService.getFeedbacks(
      page: 1,
      limit: 10000000,
      search: search,
      color: color,
      status: status,
    );

    String csvData = CSVGenerator.generateFeedbacks(res.data);
    const encoder = Utf8Encoder();
    final bytes = encoder.convert(csvData);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", 'feedbacks-bulk-export.csv')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> fetchFeedbacks() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await AdminService.getFeedbacks(
        page: currentPage,
        limit: limit,
        search: search,
        color: color,
        status: status,
      );

      setState(() {
        feedbacks = res.data;
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

  void deleteFeedbacks() async {
    try {
      await AdminService.deleteFeedbacks(feedbackIds: selectedFeedbacks);

      if (mounted) {
        const snackBar = SnackBar(content: Text('Feedbacks Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      await fetchFeedbacks();
      setState(() => selectedFeedbacks = []);
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
      fetchFeedbacks();
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      fetchFeedbacks();
    }
  }

  Color getColorForFeedback(String color) {
    if (color == 'red') return Colors.red;
    if (color == 'yellow') return Colors.yellow;
    if (color == 'green') return Colors.green;
    throw Exception('$color Not Supported');
  }

  void openFeedback(GetFeedbacksResponseData feedback) async {
    // Detail Page
    final reload = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FeedbackDetailPage(),
        settings: RouteSettings(
          arguments: feedback,
        ),
      ),
    );

    if (reload == null) {
      await fetchFeedbacks();
    }
  }

  Widget buildBody() {
    var isMobile = MediaQuery.of(context).size.width < 500;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (feedbacks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          isMobile
              ? Column(
                  children: [
                    Text(
                      'Feedbacks',
                      style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: exportCsvFile,
                      icon: const Icon(Icons.table_rows_sharp),
                      label: const Text('Export CSV'),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Feedbacks',
                      style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                    ),
                    ElevatedButton.icon(
                      onPressed: exportCsvFile,
                      icon: const Icon(Icons.table_rows_sharp),
                      label: const Text('Export CSV'),
                    )
                  ],
                ),
          const SizedBox(height: 15),
          ScrollableDataTable(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Color Code')),
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Organization')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Feedback')),
                DataColumn(label: Text('Source')),
                DataColumn(label: Text('Causes')),
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Photo')),
                DataColumn(label: Text('Reported By')),
                DataColumn(label: Text('Assigned Person')),
                DataColumn(label: Text('Action Taken')),
                DataColumn(label: Text('Photo')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('User Acknowledgement')),
              ],
              dataRowMinHeight: 100,
              dataRowMaxHeight: 100,
              rows: feedbacks
                  .map(
                    (feedback) => DataRow(

                      cells: <DataCell>[
                        DataCell(
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Container(
                              color: getColorForFeedback(feedback.color),
                            ),
                          ),
                        ),
                        DataCell(
                          Text('FB${feedback.id}'),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.location),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.organizationName),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.date),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.time),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.feedback),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.source),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.selectedValues),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.description),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              feedback.files.isNotEmpty
                                  ? Uri.parse(
                                      '$apiUrl/$feedbackData/${feedback.files[0].name}',
                                    ).toString()
                                  : '-',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onLongPress: () {
                            const snackBar = SnackBar(
                              content: Text('Link Copied'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Clipboard.setData(
                              ClipboardData(
                                text: Uri.parse(
                                  '$apiUrl/$feedbackData/${feedback.files[0].name}',
                                ).toString(),
                              ),
                            );
                          },
                          onTap: () async {
                            var anchorElement = html.AnchorElement(
                              href: Uri.parse(
                                '$apiUrl/$feedbackData/${feedback.files[0].name}',
                              ).toString(),
                            );

                            anchorElement.target = '_blank';
                            anchorElement.click();
                          },
                        ),
                        DataCell(
                          Text(feedback.reportedBy),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(
                            feedback.feedbackAssignments.isNotEmpty
                                ? feedback.feedbackAssignments[0].user.name
                                : '-',
                          ),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.actionTaken ?? '-'),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          feedback.actionFiles.isNotEmpty
                              ? Image.network(
                                  '$apiUrl/$feedbackData/${feedback.actionFiles[0].name}',
                                  width: 250,
                                  height: 250,
                                )
                              : const Text('-'),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.status?.name ?? '-'),
                          onTap: () => openFeedback(feedback),
                        ),
                        DataCell(
                          Text(feedback.acknowledgement ?? '-'),
                          onTap: () => openFeedback(feedback),
                        ),
                      ],
                      selected: selectedFeedbacks.contains(feedback.id),
                      onSelectChanged: (isItemSelected) {
                        setState(() {
                          if (isItemSelected == true) {
                            selectedFeedbacks.add(feedback.id);
                          } else {
                            selectedFeedbacks.remove(feedback.id);
                          }
                        });
                      },
                    ),
                  )
                  .toList(),
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
      drawer: isMobile ? AdminFeedbackDrawer() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: selectedFeedbacks.isNotEmpty
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
                        const SizedBox(height: 15.0),
                        ElevatedButton(
                          onPressed: deleteFeedbacks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5),
                              Text('Delete Feedbacks')
                            ],
                          ),
                        )
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10.0),
                        ElevatedButton(
                          onPressed: deleteFeedbacks,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(width: 5),
                              Text('Delete Feedbacks')
                            ],
                          ),
                        )
                      ],
                    ),
            )
          : Container(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const AdminFeedbackDrawer(),
          Expanded(child: buildBody()),
        ],
      ),
    );
  }
}
