import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';
import 'LPS.dart';

class LMA extends StatefulWidget {
  const LMA({Key? key});

  @override
  State<LMA> createState() => _LMAState();
}

class _LMAState extends State<LMA> {
  String lastGroupValue1 = "P";
  String lastGroupValue2 = "P";
  String cardGroupValue1 = "P";
  String cardGroupValue2 = "P";
  String accidentGroupValue1 = "P";
  String accidentGroupValue2 = "P";
  String accidentGroupValue3 = "P";
  String safetyGroupValue1 = "P";
  String safetyGroupValue2 = "P";
  String hopsGroupValue1 = "P";
  String hopsGroupValue2 = "P";
  String swGroupValue1 = "P";
  String communicationGroupValue1 = "P";

  bool areAllConditionsMet() {
    return lastGroupValue1 != "P" &&
        lastGroupValue2 != "P" &&
        cardGroupValue1 != "P" &&
        cardGroupValue2 != "P" &&
        accidentGroupValue1 != "P" &&
        accidentGroupValue2 != "P" &&
        accidentGroupValue3 != "P" &&
        safetyGroupValue1 != "P" &&
        safetyGroupValue2 != "P" &&
        hopsGroupValue1 != "P" &&
        hopsGroupValue2 != "P" &&
        swGroupValue1 != "P" &&
        communicationGroupValue1 != "P";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Text('Leadership and Management Accountability', style: TextStyle(color: Colors.black))),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("AREA : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("DATE : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("TEAM : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20,),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              const Text("1. LAST SAFETY WALK ACTION PLAN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('1.1 Check if all actions were taken (if applicable)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: lastGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            lastGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: lastGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            lastGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('1.2 Check if the actions were effective to control the risks (if applicable)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: lastGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            lastGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: lastGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            lastGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              const Text("2.SAFETY CARDS - CPS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('2.1 Check if all safety cards were closed in 30 days'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: cardGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            cardGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: cardGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            cardGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('2.2 Check if the improvements are being used accordingly'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: cardGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            cardGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: cardGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            cardGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("3.Accidents / Incidents investigation and Analysis".toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('3.1 Check if the RCCAs of near misses or accidents are implemented and effective'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: accidentGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            accidentGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: accidentGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            accidentGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('3.2 Check if the timeline target of RCCA implementation was met'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: accidentGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            accidentGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: accidentGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            accidentGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('3.3 Check if the timeline target of RCCA implementation was met'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: accidentGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            accidentGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: accidentGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            accidentGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("4.Safety Inspections".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('4.1 Check if all actions were taken'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: safetyGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            safetyGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: safetyGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            safetyGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('4.2 Check if there is any action still pending'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: safetyGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            safetyGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: safetyGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            safetyGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("5.Safety HOPs (Hazard Observation Process)".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('5.1 Check if the Section Manager / Leadership meet the HOP target  for the month'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: hopsGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            hopsGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: hopsGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            hopsGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('5.2 Check if there were actions from Section Manager / Leadership to improve the area\'s "safety index"'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: hopsGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            hopsGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: hopsGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            hopsGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("SW audit".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('6.1 Check if the Standard Work audit is done daily'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: swGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            swGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: swGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            swGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("7.Safety Communication".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('7.1 Check if the Section Manager / Leadership has communicated recent Injury/Near Miss information'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: communicationGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            communicationGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: communicationGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            communicationGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LPS(), // Replace NextPage with the actual name of your next page
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(primaryColor), // Set the color here
                    ),
                    child: const Text("Next",style: TextStyle(color: Colors.black),),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (areAllConditionsMet()) {
                        // Submit logic here
                        print("Submitted");
                      } else {
                        // Show a message that conditions are not met
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text("Please answer all questions."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
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
