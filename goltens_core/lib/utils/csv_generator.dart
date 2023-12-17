import 'package:csv/csv.dart';
import 'package:goltens_core/constants/constants.dart';
import 'package:goltens_core/utils/functions.dart';

class CSVGenerator {
  static String generateReadStatus(
    List<dynamic> readUsers,
    List<dynamic> unReadUsers,
  ) {
    List<List<dynamic>> data = [
      ['Name', 'Email', 'Read/Unread'],
    ];

    for (var user in readUsers) {
      data.add([user.name, user.email, 'Read']);
    }

    for (var user in unReadUsers) {
      data.add([user.name, user.email, 'Unread']);
    }

    return const ListToCsvConverter().convert(data);
  }

  static String generateFeedbacks(
    List<dynamic> feedbacks,
  ) {
    String getColorStatusString(String color) {
      if (color == 'red') return 'Stop Work and Report';
      if (color == 'yellow') return 'Use Caution and Report';
      if (color == 'green') return 'Continue and Report';
      throw Exception('$color Not Supported');
    }

    List<List<dynamic>> data = [
      [
        'id',
        'location',
        'organizationName',
        'date',
        'time',
        'feedback',
        'source',
        'feedbackType',
        'selectedValues',
        'description',
        'reportedBy',
        'responsiblePerson',
        'actionTaken',
        'status',
      ],
    ];

    for (var feedback in feedbacks) {
      data.add([
        feedback.id,
        feedback.location,
        feedback.organizationName,
        feedback.date,
        feedback.time,
        feedback.feedback,
        feedback.source,
        getColorStatusString(feedback.color),
        feedback.selectedValues.split(",").join(","),
        feedback.description,
        feedback.reportedBy,
        feedback.responsiblePerson,
        feedback.actionTaken,
        feedback.status ?? '-'
      ]);
    }

    return const ListToCsvConverter().convert(data);
  }

  static String generateMasterList(
    List<dynamic> groupsData,
    List<dynamic> masterListData,
  ) {
    List<List<dynamic>> data = [];

    List<String> columns = [
      'SNO',
      'Title',
      'Group\'s Assigned',
      'Created By',
      'Created Date',
      'Time',
      'File Link',
    ];

    for (var group in groupsData) {
      columns.add(
        '${group.name}\n(Read / Clarify / Unread)',
      );
    }

    data.add(columns);

    for (var item in masterListData) {
      final createdDate = formatDateTime(item.createdAt, 'dd/MM/y');
      final time = formatDateTime(item.createdAt, 'HH:mm');

      final messageId = formatDateTime(
        item.createdAt,
        'yyMM\'SN${item.id}\'',
      );

      final Uri url;

      if (item.files.isNotEmpty) {
        url = Uri.parse('$apiUrl/$groupData/${item.files[0].name}');
      } else {
        url = Uri.parse('');
      }

      final groupsAssigned = item.groups.map((e) => e.name).toList();

      final row = [
        messageId,
        item.title,
        groupsAssigned.join('/'),
        item.createdBy.name,
        createdDate,
        time,
        item.files.isNotEmpty ? url.toString() : '-',
      ];

      for (var group in groupsData) {
        final groupExists = item.groups.any((el) => el.id == group.id);

        // Added ("") Quotes Because Excel Converts Them To Date
        if (groupExists) {
          final value = item.groups.firstWhere((el) => el.id == group.id);
          final readCount = value.readUsersCount;
          final clarifyCount = value.clarifyUsersCount;
          final unreadCount = value.unReadUsersCount;
          row.add('"$readCount / $clarifyCount / $unreadCount"');
        } else {
          row.add('"0 / 0 / 0"');
        }
      }

      data.add(row);
    }

    return const ListToCsvConverter().convert(data);
  }

  static String generateGroupMembersList(
    String groupName,
    List<dynamic> members,
  ) {
    List<List<dynamic>> data = [
      ['Members List Of $groupName'],
      ['Name', 'Email', 'Phone', 'Department', 'Type'],
    ];

    for (var user in members) {
      data.add([
        user.name,
        user.email,
        user.phone,
        user.department,
        user.type,
      ]);
    }

    return const ListToCsvConverter().convert(data);
  }

  static String generateUserOrientationReadInfo(
    List<dynamic> userOrientationReads,
  ) {
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

    return const ListToCsvConverter().convert(data);
  }
}
