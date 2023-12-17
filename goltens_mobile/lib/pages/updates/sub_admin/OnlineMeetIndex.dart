import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goltens_core/models/meeting.dart';
import 'package:goltens_core/services/meeting.dart';
import 'package:goltens_mobile/pages/updates/employee/conference.dart';
import 'package:lottie/lottie.dart';
import 'AttendanceForm.dart';
import 'CreateLink.dart';
import 'DataExport.dart';
import 'history.dart';

class SAOnlineMeetIndex extends StatefulWidget {
  const SAOnlineMeetIndex({super.key});

  @override
  State<SAOnlineMeetIndex> createState() => _SAOnlineMeetIndexState();
}

class _SAOnlineMeetIndexState extends State<SAOnlineMeetIndex> {
  Color primaryColor = const Color(0xff80d6ff);
  final conferenceID = TextEditingController();
  final ApiService apiService = ApiService();
  final TextEditingController meetingTitleController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    conferenceID.dispose();
  }

  // Function to show the animated dialog
  Future<void> _showJoinCodeDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
          ),
          title: const Text('Join with Code'),
          content: TextFormField(
            controller: conferenceID,
            decoration: InputDecoration(
              labelText: 'Enter Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                  ),
                ),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(context).pop(); // Close the dialog
                // // Perform the join action with the entered code
                // _joinMeetingWithCode(conferenceID.text);
                // Get.to(Conference());
                Get.to((AgoraMeet(channelName: conferenceID.text.trim(),)));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                  ),
                ),
              ),
              child: const Text('Join', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Function to handle the join action with the entered code
  void _joinMeetingWithCode(String code) {
    // Implement your logic to join the meeting with the entered code
    // For example, you can navigate to the VideoConferencePage
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => VideoConferencePage(
    //       conferenceID: code,
    //     ),
    //   ),
    // );
  }

  void _createMeeting() async {
    try {
      Meeting newMeeting = Meeting(
        meetTitle: "",
        meetDateTime: DateTime.now(),
        meetCreater: '',
        meetingTime: 0,
        department: '',
        createrId: 1,
        membersCount: 47,
        isOnline: true,
        attId: 1,
        meetEndTime: DateTime.now().add(const Duration(
            hours: 2)), // Example: set the end time to 2 hours from now
        membersList: [],
        membersAttended: [], meetingId: 1,
      );

      // Format meetDateTime and meetEndTime to the specific format
      newMeeting.meetDateTime = DateTime.parse(
          '${newMeeting.meetDateTime.toIso8601String().substring(0, 19)}Z');
      newMeeting.meetEndTime = DateTime.parse(
          '${newMeeting.meetEndTime.toIso8601String().substring(0, 19)}Z');

      // Call the createMeeting method in ApiService
      await apiService.createMeeting(newMeeting);

      // Optionally, you can update the UI or navigate to another screen
    } catch (error) {
      print('Error creating meeting: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Meeting',style: TextStyle(color: Colors.black),),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'history') {
                // Perform action for history
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const History(), // Replace with the actual screen for history
                  ),
                );
              } else if (value == 'dataExport') {
                // Perform action for data export
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataExport(), // Replace with the actual screen for data export
                  ),
                );
              } else if (value == 'attendanceForm') {
                // Perform action for attendance form
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendanceForm(), // Replace with the actual screen for attendance form
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'history',
                child: ListTile(
                  leading: Icon(Icons.history, color: Colors.black),
                  title: Text('History'),
                ),

              ),
              const PopupMenuItem<String>(
                value: 'dataExport',
                child: ListTile(
                  leading: Icon(Icons.file_download, color: Colors.black),
                  title: Text('Data Export'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'attendanceForm',
                child: ListTile(
                  leading: Icon(Icons.playlist_add_check, color: Colors.black),
                  title: Text('Attendance Form'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Lottie.asset(
              'assets/json/calender.json', // Replace with your animation file path
              fit: BoxFit.contain,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: meetingTitleController,
                  decoration: InputDecoration(
                    labelText: 'Meeting Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () async {
                    _createMeeting();
                    print("$_createMeeting");
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateMeetLink(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Create Meeting', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () {
                    _showJoinCodeDialog();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.code, color: Colors.black),
                      SizedBox(width: 8),
                      Text('Join Using Code', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
