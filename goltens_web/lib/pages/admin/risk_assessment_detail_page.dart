// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goltens_core/components/admin/scrollable_data_table.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/models/admin.dart';
import 'package:goltens_core/models/risk_assessment.dart';
import 'package:goltens_core/services/admin.dart';
import 'package:goltens_core/services/risk_assessment.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:goltens_web/components/admin/admin_drawer.dart';

class RiskAssessmentDetailPage extends StatefulWidget {
  final int? groupId;

  const RiskAssessmentDetailPage({
    super.key,
    this.groupId,
  });

  @override
  State<RiskAssessmentDetailPage> createState() =>
      _RiskAssessmentDetailPageState();
}

class _RiskAssessmentDetailPageState extends State<RiskAssessmentDetailPage> {
  int currentPage = 1;
  int totalPages = 1;
  int limit = 50;
  String? search;
  bool isLoading = false;
  bool isError = false;
  GetGroupResponseData? group;
  List<GetAssessmentsResponseData> data = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final res = await fetchGroup(widget.groupId ?? 0);
      setState(() => group = res?.data);
      fetchAssessments();
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

  Future<void> fetchAssessments() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var res = await RiskAssessmentService.getRiskAssessmentItems(
        currentPage,
        limit,
        widget.groupId ?? 0,
        search,
      );

      setState(() {
        data = res.data;
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

  Future<void> updateRiskAssesment(
    int id,
    String name,
  ) async {
    try {
      await AdminService.updateRiskAssesment(id: id, name: name);
      await fetchAssessments();

      if (mounted) {
        const snackBar = SnackBar(content: Text('Updated Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showtSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 25, right: 25),
          title: const Center(child: Text("Search Risk Assessments")),
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

                              await fetchAssessments();

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

                          await fetchAssessments();

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Search Risk Assessments')
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

  void showEditRiskAssesmentDialog(
    GetAssessmentsResponseData assessment,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(25.0),
          title: const Center(child: Text("Edit Risk Assessment")),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          content: StatefulBuilder(
            builder: (
              BuildContext context,
              StateSetter setState,
            ) {
              var formKey = GlobalKey<FormState>();

              var nameTextController = TextEditingController(
                text: assessment.name.replaceAll(".pdf", ""),
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
                      Form(
                        key: formKey,
                        child: TextFormField(
                          controller: nameTextController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Please enter a name';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            formKey.currentState?.save();
                            Navigator.pop(context);
                            updateRiskAssesment(
                              assessment.id,
                              nameTextController.text,
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.done),
                            SizedBox(width: 5.0),
                            Text('Update Risk Assessment')
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

  Future<void> deleteRiskAssesment(int id) async {
    try {
      await AdminService.deleteRiskAssesment(id: id);
      await fetchAssessments();

      if (mounted) {
        const snackBar = SnackBar(content: Text('Deleted'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
      fetchAssessments();
    }
  }

  void prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
      fetchAssessments();
    }
  }

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      try {
        setState(() {
          isLoading = true;
        });

        if (!mounted) return;

        await AdminService.uploadRiskAssesment(
          byteArray: result.files.first.bytes as List<int>,
          filename: result.files.first.name,
          groupId: widget.groupId ?? 0,
        );

        setState(() {
          isLoading = false;
        });

        await fetchAssessments();
      } catch (e) {
        if (mounted) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          setState(() {
            isLoading = false;
            isError = true;
          });
        }
      }
    }
  }

  Widget buildBody() {
    var isMobile = MediaQuery.of(context).size.width < 600;

    if (data.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No Risk Assessments Available',
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
              columns: const <DataColumn>[
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Created At')),
                DataColumn(label: Text('File Link')),
                DataColumn(label: Text('Edit')),
                DataColumn(label: Text('Delete')),
              ],
              rows: data.map(
                (item) {
                  var time = formatDateTime(item.createdAt, 'HH:mm dd/MM/y');

                  var url = Uri.parse(
                    '$apiUrl/$riskAssessmentDir/${item.name}',
                  );

                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Text(item.name)),
                      DataCell(Text(time)),
                      DataCell(
                        onLongPress: () {
                          const snackBar = SnackBar(
                            content: Text('Link Copied'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar,
                          );

                          Clipboard.setData(
                            ClipboardData(text: url.toString()),
                          );
                        },
                        Text(
                          url.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () async {
                          var anchorElement = html.AnchorElement(
                            href: url.toString(),
                          );

                          anchorElement.target = '_blank';
                          anchorElement.click();
                        },
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () => showEditRiskAssesmentDialog(
                            item,
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      DataCell(
                        IconButton(
                          onPressed: () => deleteRiskAssesment(item.id),
                          color: Colors.redAccent,
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
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
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        splashRadius: 20.0,
                                      ),
                                      Text(
                                        search?.isNotEmpty == true
                                            ? 'Results for "$search"'
                                            : group?.name ?? '',
                                        style: const TextStyle(fontSize: 28.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: uploadFile,
                                    child: const SizedBox(
                                      width: 80,
                                      child: Row(
                                        children: [
                                          Icon(Icons.upload_sharp),
                                          SizedBox(width: 5),
                                          Text('Upload')
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
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        splashRadius: 20.0,
                                      ),
                                      Text(
                                        search?.isNotEmpty == true
                                            ? 'Results for "$search"'
                                            : group?.name ?? '',
                                        style: const TextStyle(fontSize: 32.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: showtSearchDialog,
                                        icon: const Icon(Icons.search),
                                        label: const Text('Search'),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton.icon(
                                        onPressed: uploadFile,
                                        icon: const Icon(Icons.upload_sharp),
                                        label: const Text('Upload'),
                                      )
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
