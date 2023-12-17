import 'package:flutter/material.dart';

class MeetingDashboardPage extends StatefulWidget {
  const MeetingDashboardPage({super.key});

  @override
  State<MeetingDashboardPage> createState() => _MeetingDashboardPageState();
}

class _MeetingDashboardPageState extends State<MeetingDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Toolbox Meeting',
              style: TextStyle(fontSize: 32.0),
            ),
            SizedBox(height: 10.0),
            Text('Coming Soon...'),
          ],
        ),
      ),
    );
  }
}
