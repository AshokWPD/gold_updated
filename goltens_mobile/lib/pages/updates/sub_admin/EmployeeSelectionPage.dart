import 'package:flutter/material.dart';

class EmployeeSelectionPage extends StatefulWidget {
  const EmployeeSelectionPage({Key? key}) : super(key: key);

  @override
  State<EmployeeSelectionPage> createState() => _EmployeeSelectionPageState();
}

class _EmployeeSelectionPageState extends State<EmployeeSelectionPage> {
  Color primaryColor = const Color(0xff80d6ff);
  TextEditingController searchController = TextEditingController();

  List<String> employees = [
    'Sundar',
    'Priya',
    'Arjun',
    'Divya',
    'Karthik',
    'Ananya',
    'Raj',
    'Meera',
    'Vijay',
    'Saranya',

    // Add more names as needed
  ];

  Set<String> selectedEmployees = Set<String>();
  List<String> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    filteredEmployees.addAll(employees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Employees',style: TextStyle(color: Colors.black),),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    filteredEmployees = employees
                        .where((employee) =>
                        employee.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Search Employees',
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(color: Colors.black), // Set the border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = filteredEmployees[index];
                  return ListTile(
                    title: Text(employee),
                    tileColor: selectedEmployees.contains(employee)
                        ? Colors.blue.withOpacity(0.3) // Highlight selected employees
                        : null,
                    onTap: () {
                      setState(() {
                        if (selectedEmployees.contains(employee)) {
                          selectedEmployees.remove(employee);
                        } else {
                          selectedEmployees.add(employee);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement logic to do something with selected employees
                // For example, you can pass the selected employees back to the previous page
                Navigator.pop(context, selectedEmployees.toList());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                  ),
                ),// Replace with your desired color
              ),
              child: const Text('Done',style: TextStyle(color: Colors.black),),
            ),
            const SizedBox(height: 50,)
          ],
        ),
      ),
    );
  }
}
