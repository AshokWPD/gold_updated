// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:goltens_web/components/admin/feedback/admin_feedback_drawer.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_core/utils/pdf_generator.dart';
import 'package:printing/printing.dart';

class FeedbackDetailPage extends StatefulWidget {
  const FeedbackDetailPage({super.key});

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  GetFeedbacksResponseData? feedback;
  Status? selectedStatus;
  final responsiblePersonController = TextEditingController();
  final actionTakenController = TextEditingController();
  final acknowledgementTakenController = TextEditingController();
  List<int> selectedRows = [];
  int? selectedUserToAdd;
  List<GetSearchUsersToAssignData> searchMembers = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final settings = ModalRoute.of(context)!.settings;
      final feedbackDetail = settings.arguments as GetFeedbacksResponseData?;

      setState(() {
        feedback = feedbackDetail;
        responsiblePersonController.text = feedback?.responsiblePerson ?? '';
        actionTakenController.text = feedback?.actionTaken ?? '';
        acknowledgementTakenController.text = feedback?.acknowledgement ?? '';
        selectedStatus = feedback?.status;
      });
    });
  }

  void showDeleteFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Do you want to delete this feedback ?"),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                Navigator.pop(context);
                deleteFeedback();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> exportPdfFile() async {
    List<dynamic> networkImages = [];
    List<dynamic> actionNetworkImages = [];

    await Future.forEach<FeedbackFile>(
      feedback?.files ?? [],
      (item) async {
        var image = await networkImage('$apiUrl/$feedbackData/${item.name}');
        networkImages.add(image);
      },
    );

    await Future.forEach<FeedbackFile>(
      feedback?.actionFiles ?? [],
      (item) async {
        var image = await networkImage('$apiUrl/$feedbackData/${item.name}');
        actionNetworkImages.add(image);
      },
    );

    var uri = Uri.parse(apiUrl);
    var logoImage = await networkImage('${uri.origin}/assets/images/logo.png');

    // Save the PDF file
    Uint8List pdfInBytes = await PDFGenerator.generateFeedbackDetail(
      feedback?.id ?? 0,
      feedback?.createdBy.name ?? '',
      feedback?.createdBy.email ?? '',
      feedback?.createdBy.phone ?? '',
      feedback?.location ?? '',
      feedback?.organizationName ?? '',
      feedback?.date ?? '',
      feedback?.time ?? '',
      feedback?.feedback ?? '',
      feedback?.source ?? '',
      feedback?.color ?? '',
      feedback?.selectedValues ?? '',
      feedback?.description ?? '',
      feedback?.reportedBy ?? '',
      feedback?.feedbackAssignments.isNotEmpty == true
          ? feedback?.feedbackAssignments[0].user.name ?? ''
          : '',
      feedback?.actionTaken ?? '',
      feedback?.status.toString().split('.').last ?? '',
      logoImage,
      feedback!.files,
      networkImages,
      feedback!.actionFiles,
      actionNetworkImages,
    );

    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", 'feedback-FB${feedback?.id}.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> deleteFeedback() async {
    try {
      await AdminService.deleteFeedbacks(feedbackIds: [feedback?.id ?? 0]);

      if (mounted) {
        const snackBar = SnackBar(content: Text('Feedback Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  String? validateForm() {
    if (actionTakenController.text.isEmpty) {
      return 'Enter action taken';
    }

    if (selectedStatus == null) {
      return 'Select a status';
    }

    return null;
  }

  void updateFeedback() async {
    String? validationError = validateForm();

    if (validationError != null) {
      final snackBar = SnackBar(content: Text(validationError));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    try {
      var res = await AdminService.updateFeedback(
        id: feedback?.id ?? 0,
        responsiblePerson: responsiblePersonController.text,
        actionTaken: actionTakenController.text,
        status: selectedStatus?.name ?? '',
      );

      if (mounted) {
        final snackBar = SnackBar(content: Text(res.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  Color getColorForFeedback(String color) {
    if (color == 'red') return Colors.red;
    if (color == 'yellow') return Colors.yellow;
    if (color == 'green') return Colors.green;
    throw Exception('$color Not Supported');
  }

  String getColorStatusString(String color) {
    if (color == 'red') return 'Stop Work and Report';
    if (color == 'yellow') return 'Use Caution and Report';
    if (color == 'green') return 'Continue and Report';
    throw Exception('$color Not Supported');
  }

  Future<GetSearchUsersToAssignResponse?> searchUsersToAssignFeedback(
    String search,
  ) async {
    try {
      var res = await AdminService.searchUsersToAssignForFeedback(
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

  void showAssignUsersDialog() {
    setState(() => selectedRows = []);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Assign User")),
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

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar,
                                  );
                                }

                                return;
                              }

                              var users = await searchUsersToAssignFeedback(
                                searchTextController.text,
                              );

                              if (users != null) {
                                setState(() {
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
                          ? SizedBox(
                              height: 200,
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
                                  rows: searchMembers
                                      .map(
                                        (user) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              CircleAvatar(
                                                radius: 16,
                                                child: user.avatar.isNotEmpty ==
                                                        true
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
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
                                          selected:
                                              user.id == selectedUserToAdd,
                                          onSelectChanged: (isItemSelected) {
                                            setState(() {
                                              selectedUserToAdd = user.id;
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
                      Text('Only one user allowed to be assigned',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: searchMembers.isNotEmpty
                            ? () {
                                Navigator.pop(context);
                                assignUsersToFeedbackReport();
                              }
                            : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.group_add),
                            SizedBox(width: 5.0),
                            Text('Assign User')
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

  void assignUsersToFeedbackReport() async {
    try {
      var res = await AdminService.assignUserToFeedback(
        feedbackId: feedback!.id,
        userId: selectedUserToAdd ?? 0,
      );

      setState(() {
        feedback?.feedbackAssignments = res.data.feedbackAssignments;
      });

      if (mounted) {
        const snackBar = SnackBar(content: Text('User Assigned!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      setState(() {
        selectedRows = [];
        searchMembers = [];
      });
    }
  }

  Widget buildBody() {
    final checkedValues = feedback?.selectedValues.split(',').join(',');
    var isMobile = MediaQuery.of(context).size.width < 500;

    if (feedback == null) {
      return Container();
    }

    return SingleChildScrollView(
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
                          ),
                          Text(
                            'Feedback Detail (FB${feedback?.id})',
                            style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: showAssignUsersDialog,
                        icon: const Icon(Icons.group_add),
                        label: const Text('Assign User'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: exportPdfFile,
                        icon: const Icon(Icons.document_scanner),
                        label: const Text('Export PDF'),
                      ),
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
                          ),
                          Text(
                            'Feedback Detail (FB${feedback?.id})',
                            style: TextStyle(fontSize: isMobile ? 28.0 : 32.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: showAssignUsersDialog,
                            icon: const Icon(Icons.group_add),
                            label: const Text('Assign User'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: exportPdfFile,
                            icon: const Icon(Icons.document_scanner),
                            label: const Text('Export PDF'),
                          ),
                        ],
                      )
                    ],
                  ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    color: getColorForFeedback(feedback?.color ?? ''),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      getColorStatusString(feedback?.color ?? 'green'),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${'Location'.padRight(27)}: ${feedback?.location}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 6),
            Text(
              '${'Date & Time'.padRight(24)}: ${feedback?.date} ${feedback?.time}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 6),
            Text(
              '${'Organization'.padRight(24)}: ${feedback?.organizationName}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 6),
            Text(
              '${'Source'.padRight(28)}: ${feedback?.source}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 6),
            Text(
              '${'Checked Values'.padRight(20)}: $checkedValues',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 6),
            Text(
              '${'Description'.padRight(25)}: ${feedback?.description}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 6),
            Text(
              '${'Reported By'.padRight(24)}: ${feedback?.reportedBy}',
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 12),
            feedback != null && feedback?.files.isEmpty == true
                ? const Text('No Photos Attached')
                : Container(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: feedback?.files.mapIndexed((index, file) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          '$apiUrl/$feedbackData/${file.name}',
                          width: 180,
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }).toList() ??
                  [],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Assigned User',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            feedback != null && feedback?.feedbackAssignments.isEmpty == true
                ? const Text('No User Assigned')
                : Container(),
            Column(
              children: feedback?.feedbackAssignments.map((obj) {
                    var assignmentCompleted = false;

                    for (var assignment in feedback!.feedbackAssignments) {
                      if (assignment.userId == obj.userId &&
                          assignment.feedbackId == feedback?.id) {
                        assignmentCompleted = assignment.assignmentCompleted;
                        break;
                      }
                    }

                    return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: obj.user.avatar.isNotEmpty == true
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: Image.network(
                                    '$apiUrl/$avatar/${obj.user.avatar}',
                                    errorBuilder: (
                                      context,
                                      obj,
                                      stacktrace,
                                    ) {
                                      return Container();
                                    },
                                  ),
                                )
                              : Text(obj.user.name[0]),
                        ),
                        title: Text(obj.user.name),
                        subtitle: Text(obj.user.email),
                        trailing: assignmentCompleted
                            ? SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text('Completed'),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text('Pending'),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.do_disturb_alt,
                                          color: Colors.white,
                                          size: 18.0,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    );
                  }).toList() ??
                  const [
                    Text('No Assigned User'),
                  ],
            ),
            feedback?.feedbackAssignments.isNotEmpty == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          selectedUserToAdd =
                              feedback!.feedbackAssignments[0].userId;

                          showAssignUsersDialog();
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Assigned User'),
                      )
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Action Taken',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 20),
            TextFormField(
              minLines: 3,
              maxLines: null,
              controller: actionTakenController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                label: const Text('Action Taken'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: feedback?.feedbackAssignments.isNotEmpty == true,
              child: feedback != null && feedback?.actionFiles.isEmpty == true
                  ? const Text('No Photos Attached By Assigned Person')
                  : Column(
                      children: feedback?.actionFiles.mapIndexed((index, file) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Image.network(
                                    '$apiUrl/$feedbackData/${file.name}',
                                    width: 180,
                                  ),
                                  onTap: () async {
                                    var url =
                                        '$apiUrl/$feedbackData/${file.name}';

                                    var anchorElement = html.AnchorElement(
                                      href: url.toString(),
                                    );

                                    anchorElement.target = '_blank';
                                    anchorElement.click();
                                  },
                                ),
                                const SizedBox(height: 8),
                              ],
                            );
                          }).toList() ??
                          [],
                    ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: feedback?.acknowledgement?.isNotEmpty == true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'User Acknowledgement',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    minLines: 3,
                    maxLines: null,
                    enabled: false,
                    controller: acknowledgementTakenController,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      label: const Text('Acknowledgement'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Text(
              'Status',
              style: TextStyle(fontSize: 18.0),
            ),
            Column(
              children: [
                RadioListTile<Status>(
                  title: const Text('In Progress'),
                  value: Status.inProgress,
                  groupValue: selectedStatus,
                  contentPadding: const EdgeInsets.all(0.0),
                  onChanged: (value) {
                    setState(() => selectedStatus = value);
                  },
                ),
                RadioListTile<Status>(
                  title: const Text('Rejected'),
                  value: Status.rejected,
                  groupValue: selectedStatus,
                  contentPadding: const EdgeInsets.all(0.0),
                  onChanged: (value) {
                    setState(() => selectedStatus = value);
                  },
                ),
                RadioListTile<Status>(
                  title: const Text('Closed'),
                  value: Status.closed,
                  groupValue: selectedStatus,
                  contentPadding: const EdgeInsets.all(0.0),
                  onChanged: (value) {
                    setState(() => selectedStatus = value);
                  },
                ),
                RadioListTile<Status>(
                  title: const Text('Closed Without Action'),
                  value: Status.closedWithoutAction,
                  groupValue: selectedStatus,
                  contentPadding: const EdgeInsets.all(0.0),
                  onChanged: (value) {
                    setState(() => selectedStatus = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: updateFeedback,
              icon: const Icon(Icons.done),
              label: const Text('Update Feedback'),
            )
          ],
        ),
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
      body: Row(
        children: [
          if (!isMobile) const AdminFeedbackDrawer(),
          Expanded(
            child: buildBody(),
          ),
        ],
      ),
    );
  }
}
