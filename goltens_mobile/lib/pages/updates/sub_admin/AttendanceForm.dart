import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';

class AttendanceForm extends StatelessWidget {
  const AttendanceForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendanceForm',style: TextStyle(color: Colors.black),),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text('Attendance Form'),
      ),
    );
  }
}
