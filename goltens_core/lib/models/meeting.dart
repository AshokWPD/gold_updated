class Meeting {
  int meetingId;
  String meetCreater;
  DateTime meetDateTime;
  String meetTitle;
  int meetingTime;
  String department;
  int createrId;
  int membersCount;
  bool isOnline;
  int attId;
  DateTime meetEndTime;
  List<MembersList> membersList;
  List<MembersAttended> membersAttended;

  Meeting({
    required this.meetingId,
    required this.meetCreater,
    required this.meetDateTime,
    required this.meetTitle,
    required this.meetingTime,
    required this.department,
    required this.createrId,
    required this.membersCount,
    required this.isOnline,
    required this.attId,
    required this.meetEndTime,
    required this.membersList,
    required this.membersAttended,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      meetingId: json['meetingId'],
      meetCreater: json['meetCreater'],
      meetDateTime: DateTime.parse(json['meetDateTime']),
      meetTitle: json['meetTitle'],
      meetingTime: json['meetingTime'],
      department: json['department'],
      createrId: json['createrId'],
      membersCount: json['membersCount'],
      isOnline: json['isOnline'],
      attId: json['attId'],
      meetEndTime: DateTime.parse(json['meetEndTime']),
      membersList: List<MembersList>.from(
        json['membersList']?.map((x) => MembersList.fromJson(x)) ?? [],
      ),
      membersAttended: List<MembersAttended>.from(
        json['membersAttended']?.map((x) => MembersAttended.fromJson(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meetingId': meetingId,
      'meetCreater': meetCreater,
      'meetDateTime': meetDateTime.toIso8601String(),
      'meetTitle': meetTitle,
      'meetingTime': meetingTime,
      'department': department,
      'createrId': createrId,
      'membersCount': membersCount,
      'isOnline': isOnline,
      'attId': attId,
      'meetEndTime': meetEndTime.toIso8601String(),
      'membersList': membersList?.map((x) => x.toJson())?.toList(),
      'membersAttended': membersAttended?.map((x) => x.toJson())?.toList(),
    };
  }
}

class MembersList {
  int id;
  String memberId;
  String memberName;
  int meetingId;

  MembersList({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.meetingId,
  });

  factory MembersList.fromJson(Map<String, dynamic> json) {
    return MembersList(
      id: json['id'],
      memberId: json['memberId'],
      memberName: json['memberName'],
      meetingId: json['meetingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'memberName': memberName,
      'meetingId': meetingId,
    };
  }
}

class MembersAttended {
  int id;
  int memberId;
  String membersName;
  DateTime memberInTime;
  DateTime memberOutTime;
  DateTime dateTime;
  double latitude;
  double longitude;
  DigitalSignatureFile digitalSignatureFile;
  int meetingId;

  MembersAttended({
    required this.id,
    required this.memberId,
    required this.membersName,
    required this.memberInTime,
    required this.memberOutTime,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.digitalSignatureFile,
    required this.meetingId,
  });

  factory MembersAttended.fromJson(Map<String, dynamic> json) {
    return MembersAttended(
      id: json['id'],
      memberId: json['memberId'],
      membersName: json['membersName'],
      memberInTime: DateTime.parse(json['memberInTime']),
      memberOutTime: DateTime.parse(json['memberOutTime']),
      dateTime: DateTime.parse(json['dateTime']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      digitalSignatureFile: DigitalSignatureFile.fromJson(json['digitalSignatureFile']),
      meetingId: json['meetingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberId': memberId,
      'membersName': membersName,
      'memberInTime': memberInTime.toIso8601String(),
      'memberOutTime': memberOutTime.toIso8601String(),
      'dateTime': dateTime.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'digitalSignatureFile': digitalSignatureFile.toJson(),
      'meetingId': meetingId,
    };
  }
}

class DigitalSignatureFile {
  int fileId;
  String name;
  String fileType;
  String path;
  int attendanceId;

  DigitalSignatureFile({
    required this.fileId,
    required this.name,
    required this.fileType,
    required this.path,
    required this.attendanceId,
  });

  factory DigitalSignatureFile.fromJson(Map<String, dynamic> json) {
    return DigitalSignatureFile(
      fileId: json['fileId'],
      name: json['name'],
      fileType: json['fileType'],
      path: json['path'],
      attendanceId: json['attendanceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileId': fileId,
      'name': name,
      'fileType': fileType,
      'path': path,
      'attendanceId': attendanceId,
    };
  }
}