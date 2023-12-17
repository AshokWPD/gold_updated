import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';
import 'package:lottie/lottie.dart';
import 'OfflineMeetIndex.dart';
import 'OnlineMeetIndex.dart';

class SAMeetJoinPage extends StatelessWidget {
  const SAMeetJoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Meeting',style: TextStyle(color: Colors.black),),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/json/meet.json', // Replace with your animation file path
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(right: 20.0,left: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Show a dialog to ask whether it's an offline or online meeting
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SAOnlineMeetIndex(),
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
                      Icon(Icons.video_call, color: Colors.black), // Replace with the desired icon
                      SizedBox(width: 8), // Adjust the spacing between the icon and text
                      Text('Online Meeting', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20.0,left: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Show a dialog to ask whether it's an offline or online meeting
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SAOfflineMeetIndex(),
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
                      Icon(Icons.calendar_today, color: Colors.black), // Replace with the desired icon
                      SizedBox(width: 8), // Adjust the spacing between the icon and text
                      Text('Offline Meeting', style: TextStyle(color: Colors.black)),
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
