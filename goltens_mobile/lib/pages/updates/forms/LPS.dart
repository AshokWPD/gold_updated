import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';
import 'BSO.dart';

class LPS extends StatefulWidget {
  const LPS({Key? key});

  @override
  State<LPS> createState() => _LPSState();
}

class _LPSState extends State<LPS> {
  String Question1 = "P";
  String Question2 = "P";
  String Question3 = "P";
  String Question4 = "P";
  String Question5 = "P";

  // Boolean variables to track if descriptions are filled
  bool isDescription1Filled = false;
  bool isDescription2Filled = false;
  bool isDescription3Filled = false;
  bool isDescription4Filled = false;
  bool isDescription5Filled = false;

  bool areAllConditionsMet() {
    return Question1 != "P" &&
        Question2 != "P" &&
        Question3 != "P" &&
        Question4 != "P" &&
        Question5 != "P" &&
        isDescription1Filled &&
        isDescription2Filled &&
        isDescription3Filled &&
        isDescription4Filled &&
        isDescription5Filled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            'Leadership Perception Survey',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Column(
                children: [
                  const Text(
                    "Leadership and Management Accountability",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(thickness: 2,),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "1. Do you feel you are working in a safe workplace?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: Question1,
                        onChanged: (value) {
                          setState(() {
                            Question1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: Question1,
                        onChanged: (value) {
                          setState(() {
                            Question1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        // Handle the description input
                        setState(() {
                          isDescription1Filled = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "2.Are you aware of hazards in your work? Are there any protective measures present? Give examples:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: Question2,
                        onChanged: (value) {
                          setState(() {
                            Question2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: Question2,
                        onChanged: (value) {
                          setState(() {
                            Question2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        // Handle the description input
                        setState(() {
                          isDescription2Filled = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "3.Does your section manager stop any unsafe work? Give examples:",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: Question3,
                        onChanged: (value) {
                          setState(() {
                            Question3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: Question3,
                        onChanged: (value) {
                          setState(() {
                            Question3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        // Handle the description input
                        setState(() {
                          isDescription3Filled = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "4.When you report hazards to your section manager, Does He/She reply back to you and give solutions? Give example:",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: Question4,
                        onChanged: (value) {
                          setState(() {
                            Question4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: Question4,
                        onChanged: (value) {
                          setState(() {
                            Question4 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        // Handle the description input
                        setState(() {
                          isDescription4Filled = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "5.Do you feel and see the supervisors and managers showing their commitment to safety? Give examples:",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: Question5,
                        onChanged: (value) {
                          setState(() {
                            Question5 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: Question5,
                        onChanged: (value) {
                          setState(() {
                            Question5 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        // Handle the description input
                        setState(() {
                          isDescription5Filled = value.isNotEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BSO(),
                        ),
                      );
                    },style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(primaryColor), // Set the color here
                  ),
                    child: const Text("Next",style: TextStyle(color: Colors.black),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (areAllConditionsMet()) {
                        // Calculate conformance index
                        double conformanceIndex1 =
                        (Question1 == "Yes") ? 100.0 : 0.0;
                        double conformanceIndex2 =
                        (Question2 == "Yes") ? 100.0 : 0.0;
                        double conformanceIndex3 =
                        (Question3 == "Yes") ? 100.0 : 0.0;
                        double conformanceIndex4 =
                        (Question4 == "Yes") ? 100.0 : 0.0;
                        double conformanceIndex5 =
                        (Question5 == "Yes") ? 100.0 : 0.0;

                        double totalConformanceIndex = conformanceIndex1 +
                            conformanceIndex2 +
                            conformanceIndex3 +
                            conformanceIndex4 +
                            conformanceIndex5;

                        double totalResponses = (Question1 == "Yes" || Question1 == "No" ? 1 : 0) +
                            (Question2 == "Yes" || Question2 == "No" ? 1 : 0) +
                            (Question3 == "Yes" || Question3 == "No" ? 1 : 0) +
                            (Question4 == "Yes" || Question4 == "No" ? 1 : 0) +
                            (Question5 == "Yes" || Question5 == "No" ? 1 : 0);

                        double conformancePercentage =
                        (totalResponses != 0) ? (totalConformanceIndex / totalResponses) * 100 : 0.0;

                        print("Total Positive Responses: $totalConformanceIndex");
                        print("Total Negative Responses: ${totalResponses - totalConformanceIndex}");
                        print("Conformance Percentage: $conformancePercentage%");
                      } else {
                        // Show a message that conditions are not met
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                  "Please answer all questions and provide descriptions."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK",style: TextStyle(color: Colors.black),),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor), // Set the color here
                    ),
                    child: const Text("Submit",style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
