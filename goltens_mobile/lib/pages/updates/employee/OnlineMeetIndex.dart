import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'conference.dart';

class EmpOnlineMeetIndex extends StatefulWidget {
  const EmpOnlineMeetIndex({super.key});

  @override
  State<EmpOnlineMeetIndex> createState() => _EmpOnlineMeetIndexState();
}

class _EmpOnlineMeetIndexState extends State<EmpOnlineMeetIndex> {
  Color primaryColor = const Color(0xff80d6ff);
  final conferenceID = TextEditingController();

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
          content: TextField(
            controller: conferenceID,
            decoration: InputDecoration(
              labelText: 'Enter Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
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
                // Get.to(EmpConference());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting',style: TextStyle(color: Colors.black),),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
          actions: const [
            Icon(Icons.notification_add),
            SizedBox(width: 20,),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.work_history_rounded),
            )
          ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Lottie.asset(
                'assets/json/calender.json', // Replace with your animation file path
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40,right: 40),
                child: ElevatedButton(
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
                      Icon(
                        Icons.code, // Replace with the desired icon
                        color: Colors.black,
                      ),
                      SizedBox(width: 8), // Adjust the spacing between icon and text as needed
                      Text(
                        'Join Using Code',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
