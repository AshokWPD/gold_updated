import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';

class DataExport extends StatelessWidget {
  const DataExport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Export',style: TextStyle(color: Colors.black),),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text('Data Export'),
      ),
    );
  }
}
