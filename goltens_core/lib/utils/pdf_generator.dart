import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:goltens_core/utils/functions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;

class PDFGenerator {
  static pdf.Row generateHeader(
    dynamic logoImage,
    String title,
  ) {
    return pdf.Row(
      mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pdf.CrossAxisAlignment.center,
      children: [
        kIsWeb
            ? pdf.Image(
                logoImage,
                width: 50,
                height: 50,
                alignment: pdf.Alignment.center,
              )
            : pdf.Image(
                pdf.MemoryImage(logoImage),
                width: 50,
                height: 50,
                alignment: pdf.Alignment.center,
              ),
        pdf.Text(
          title,
          textAlign: pdf.TextAlign.center,
          style: const pdf.TextStyle(
            decoration: pdf.TextDecoration.underline,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  static Future<Uint8List> generateReadStatus(
    int id,
    String content,
    DateTime createdAt,
    dynamic logoImage,
    List<dynamic> readUsers,
    List<dynamic> unReadUsers,
  ) async {
    final pdf.Document doc = pdf.Document();

    List<List<dynamic>> data = [
      ['Name', 'Email', 'Read/Unread'],
    ];

    for (var user in readUsers) {
      data.add([user.name, user.email, 'Read']);
    }

    for (var user in unReadUsers) {
      data.add([user.name, user.email, 'Unread']);
    }

    List<pdf.TableRow> tableRows = [];

    for (var rowData in data) {
      List<pdf.Widget> row = [];

      for (var cellData in rowData) {
        row.add(
          pdf.Paragraph(
            margin: const pdf.EdgeInsets.all(5.0),
            text: cellData,
          ),
        );
      }

      tableRows.add(pdf.TableRow(children: row));
    }

    var messageId = formatDateTime(createdAt, 'yyMM\'SN\'$id');

    doc.addPage(
      pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return [
            generateHeader(logoImage, 'Read Status of $content - $messageId'),
            pdf.SizedBox(height: 20),
            pdf.Table(
              border: pdf.TableBorder.all(width: 1),
              children: tableRows,
            ),
          ];
        },
      ),
    );

    return await doc.save();
  }

  static Future<Uint8List> generateMessageChanges(
    int id,
    String content,
    dynamic logoImage,
    DateTime createdAt,
    List<dynamic> data,
  ) async {
    var messageId = formatDateTime(createdAt, 'yyMM\'SN\'$id');
    final doc = pdf.Document();

    doc.addPage(
      pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return [
            generateHeader(
              logoImage,
              'Message Changes - ($messageId) $content',
            ),
            pdf.SizedBox(height: 20.0),
            pdf.Column(
              children: data.map((item) {
                var readInfo = item.reads.mapIndexed((index, e) {
                  var time = formatDateTime(e.readAt, 'HH:mm dd/mm/y');

                  return '${index + 1}) ${e.reply} (${e.mode}) - $time';
                }).join('\n');

                return pdf.Column(
                  mainAxisAlignment: pdf.MainAxisAlignment.start,
                  crossAxisAlignment: pdf.CrossAxisAlignment.start,
                  children: [
                    pdf.Text(
                      '${item.name} (${item.email})',
                      style: const pdf.TextStyle(fontSize: 18.0),
                      textAlign: pdf.TextAlign.left,
                    ),
                    pdf.SizedBox(height: 8),
                    pdf.Text(readInfo),
                    pdf.Divider(),
                  ],
                );
              }).toList(),
            ),
          ];
        },
      ),
    );

    return await doc.save();
  }

  static Future<Uint8List> generateFeedbackDetail(
    int id,
    String createdName,
    String createdEmail,
    String createdPhone,
    String location,
    String organizationName,
    String date,
    String time,
    String feedback,
    String source,
    String color,
    String selectedValues,
    String description,
    String reportedBy,
    String responsiblePerson,
    String actionTaken,
    String status,
    dynamic logoImage,
    List<dynamic> files,
    List<dynamic> images,
    List<dynamic> actionTakenFiles,
    List<dynamic> actionTakenImages,
  ) async {
    final doc = pdf.Document();

    doc.addPage(
      pdf.Page(
        build: (pdf.Context context) {
          return pdf.Column(
            mainAxisAlignment: pdf.MainAxisAlignment.center,
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            mainAxisSize: pdf.MainAxisSize.max,
            children: [
              generateHeader(
                logoImage,
                'Feedback Report - FB$id',
              ),
              pdf.SizedBox(height: 20.0),
              pdf.Container(
                decoration: pdf.BoxDecoration(
                  borderRadius: const pdf.BorderRadius.all(
                    pdf.Radius.circular(15.0),
                  ),
                  border: pdf.Border.all(
                    width: 1,
                    color: PdfColors.black,
                  ),
                ),
                child: pdf.Padding(
                  padding: const pdf.EdgeInsets.all(16.0),
                  child: pdf.Column(
                    crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
                    mainAxisAlignment: pdf.MainAxisAlignment.start,
                    children: [
                      pdf.Text(
                        'Sender Details',
                        textAlign: pdf.TextAlign.center,
                        style: const pdf.TextStyle(
                          fontSize: 20.0,
                          decoration: pdf.TextDecoration.underline,
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Name: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: createdName,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Email: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: createdEmail,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Phone: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: createdPhone,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              pdf.SizedBox(height: 10.0),
              pdf.SizedBox(height: 10.0),
              pdf.Container(
                decoration: pdf.BoxDecoration(
                  borderRadius: const pdf.BorderRadius.all(
                    pdf.Radius.circular(15.0),
                  ),
                  border: pdf.Border.all(
                    width: 1,
                    color: PdfColors.black,
                  ),
                ),
                child: pdf.Padding(
                  padding: const pdf.EdgeInsets.all(16.0),
                  child: pdf.Column(
                    crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
                    mainAxisAlignment: pdf.MainAxisAlignment.start,
                    children: [
                      pdf.Text(
                        'Form Details',
                        textAlign: pdf.TextAlign.center,
                        style: const pdf.TextStyle(
                          fontSize: 20.0,
                          decoration: pdf.TextDecoration.underline,
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Location: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: location,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Organization Name: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: organizationName,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Date: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: date,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Time: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: time,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Feedback: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: feedback,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Source: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: source,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Color: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: color,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Selected Values: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: selectedValues,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Description: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: description,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Reported By: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: reportedBy,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
              pdf.SizedBox(height: 10.0),
              pdf.SizedBox(height: 10.0),
              pdf.Container(
                decoration: pdf.BoxDecoration(
                  borderRadius: const pdf.BorderRadius.all(
                    pdf.Radius.circular(15.0),
                  ),
                  border: pdf.Border.all(
                    width: 1,
                    color: PdfColors.black,
                  ),
                ),
                child: pdf.Padding(
                  padding: const pdf.EdgeInsets.all(16.0),
                  child: pdf.Column(
                    crossAxisAlignment: pdf.CrossAxisAlignment.stretch,
                    mainAxisAlignment: pdf.MainAxisAlignment.start,
                    children: [
                      pdf.Text(
                        'Admin Response',
                        textAlign: pdf.TextAlign.center,
                        style: const pdf.TextStyle(
                          fontSize: 20.0,
                          decoration: pdf.TextDecoration.underline,
                        ),
                      ),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Responsible Person: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: responsiblePerson,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Action Taken: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: actionTaken,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                      pdf.RichText(
                        text: pdf.TextSpan(
                          children: <pdf.TextSpan>[
                            pdf.TextSpan(
                              text: 'Status: ',
                              style: pdf.TextStyle(
                                fontWeight: pdf.FontWeight.bold,
                              ),
                            ),
                            pdf.TextSpan(
                              text: status,
                            )
                          ],
                        ),
                      ),
                      pdf.SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    doc.addPage(
      pdf.Page(
        build: (pdf.Context context) {
          return pdf.Column(
            children: [
              generateHeader(logoImage, 'Images'),
              pdf.SizedBox(height: 20),
              pdf.GridView(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                children: files.isNotEmpty
                    ? files.mapIndexed((index, file) {
                        return kIsWeb
                            ? pdf.Image(
                                images[index],
                                height: 220,
                              )
                            : pdf.Image(
                                pdf.MemoryImage(images[index]!),
                                height: 220,
                              );
                      }).toList()
                    : [
                        pdf.Text('No Images Were Attached'),
                      ],
              ),
            ],
          );
        },
      ),
    );

    doc.addPage(
      pdf.Page(
        build: (pdf.Context context) {
          return pdf.Column(
            children: [
              generateHeader(logoImage, 'Images'),
              pdf.SizedBox(height: 20),
              pdf.GridView(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                children: actionTakenFiles.isNotEmpty
                    ? actionTakenFiles.mapIndexed((index, file) {
                        return kIsWeb
                            ? pdf.Image(
                                actionTakenImages[index],
                                height: 220,
                              )
                            : pdf.Image(
                                pdf.MemoryImage(actionTakenImages[index]!),
                                height: 220,
                              );
                      }).toList()
                    : [
                        pdf.Text('No Images Were Attached'),
                      ],
              ),
            ],
          );
        },
      ),
    );

    return await doc.save();
  }

  static Future<Uint8List> generateUserOrientationReadInfo(
    int id,
    String name,
    DateTime createdAt,
    dynamic logoImage,
    List<dynamic> userOrientationReads,
  ) async {
    final pdf.Document doc = pdf.Document();

    List<List<dynamic>> data = [
      ['Name', 'Email', 'Read At'],
    ];

    for (var userRead in userOrientationReads) {
      data.add(
        [
          userRead.user.name,
          userRead.user.email,
          formatDateTime(userRead.readAt, 'HH:mm dd/mm/y')
        ],
      );
    }

    List<pdf.TableRow> tableRows = [];

    for (var rowData in data) {
      List<pdf.Widget> row = [];

      for (var cellData in rowData) {
        row.add(
          pdf.Paragraph(
            margin: const pdf.EdgeInsets.all(5.0),
            text: cellData,
          ),
        );
      }

      tableRows.add(pdf.TableRow(children: row));
    }

    var messageId = 'User Orientation Info ($name) - $id';

    doc.addPage(
      pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return [
            generateHeader(logoImage, messageId),
            pdf.SizedBox(height: 20),
            pdf.Table(
              border: pdf.TableBorder.all(width: 1),
              children: tableRows,
            ),
          ];
        },
      ),
    );

    return await doc.save();
  }
}
