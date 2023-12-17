import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';
import 'LPS.dart';

class BSO extends StatefulWidget {
  const BSO({Key? key});

  @override
  State<BSO> createState() => _BSOState();
}

class _BSOState extends State<BSO> {
  String PPE1 = "P";
  String PPE2= "P";
  String PPE3 = "P";
  String PPE4 = "P";
  String body1 = "P";
  String body2 = "P";
  String body3 = "P";
  String body4 = "P";
  String body5 = "P";
  String body6 = "P";
  String body7 = "P";
  String body8 = "P";
  String chemical1 = "P";
  String chemical2 = "P";
  String chemical3 = "P";
  String chemical4 = "P";
  String procedure1 = "P";
  String procedure2 = "P";
  String procedure3 = "P";
  String procedure4 = "P";
  String house1 = "P";
  String house2 = "P";
  String house3 = "P";
  String house4 = "P";
  String house5 = "P";
  String tools1 = "P";
  String tools2 = "P";
  String tools3 = "P";
  String tools4 = "P";
  String tools5 = "P";
  String tools6 = "P";
  String tools7 = "P";

  bool isDescription1Filled = false;
  bool isDescription2Filled = false;
  bool isDescription3Filled = false;

  bool areAllConditionsMet() {
    return PPE1 != "P" &&
        PPE2 != "P" &&
        PPE3 != "P" &&
        PPE4 != "P" &&
        body1 != "P" &&
        body2 != "P" &&
        body3 != "P" &&
        body4 != "P" &&
        body5 != "P" &&
        body6 != "P" &&
        body7 != "P" &&
        body8 != "P" &&
        chemical1 != "P" &&
        chemical2 != "P" &&
        chemical3 != "P" &&
        chemical4 != "P" &&
        procedure1 != "P" &&
        procedure2 != "P" &&
        procedure3 != "P" &&
        procedure4 != "P" &&
        house1 != "P" &&
        house2 != "P" &&
        house3 != "P" &&
        house4 != "P" &&
        house5 != "P" &&
        tools1 != "P" &&
        tools2 != "P" &&
        tools3 != "P" &&
        tools4 != "P" &&
        tools5 != "P" &&
        tools6 != "P" &&
        tools7 != "P" ;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("LOCATION : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("OBSERVER 1 : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("EMPLOYEE : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("TASK : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("OBSERVER 2 : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("DATE : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20,),
              const Divider(thickness: 2,),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("S - Safe", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("AR - At Risk", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 20,),
              const Divider(thickness: 2,),
              const Text("PPE", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('PPE worn'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: PPE1,
                        onChanged: (value) {
                          setState(() {
                            PPE1 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: PPE1,
                        onChanged: (value) {
                          setState(() {
                            PPE1 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('PPE meets job requirements'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: PPE2,
                        onChanged: (value) {
                          setState(() {
                            PPE2 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: PPE2,
                        onChanged: (value) {
                          setState(() {
                            PPE2 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Worn correctly'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: PPE3,
                        onChanged: (value) {
                          setState(() {
                            PPE3 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: PPE3,
                        onChanged: (value) {
                          setState(() {
                            PPE3 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Acceptable condition'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: PPE4,
                        onChanged: (value) {
                          setState(() {
                            PPE4 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: PPE4,
                        onChanged: (value) {
                          setState(() {
                            PPE4 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("Body Position and Ergonomics".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('Exertion: Pushing /pulling /lifting/reaching'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body1,
                        onChanged: (value) {
                          setState(() {
                            body1 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body1,
                        onChanged: (value) {
                          setState(() {
                            body1 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Proper lifting carrying mechanism'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body2,
                        onChanged: (value) {
                          setState(() {
                            body2 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body2,
                        onChanged: (value) {
                          setState(() {
                            body2 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Clear of "line of fire"'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body3,
                        onChanged: (value) {
                          setState(() {
                            body3 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body3,
                        onChanged: (value) {
                          setState(() {
                            body3 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Eyes on path'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body4,
                        onChanged: (value) {
                          setState(() {
                            body4 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body4,
                        onChanged: (value) {
                          setState(() {
                            body4 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Eyes on work'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body5,
                        onChanged: (value) {
                          setState(() {
                            body5 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body5,
                        onChanged: (value) {
                          setState(() {
                            body5 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Clear of pinch points'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body6,
                        onChanged: (value) {
                          setState(() {
                            body6 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body6,
                        onChanged: (value) {
                          setState(() {
                            body6 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Clear of sharp edges'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body7,
                        onChanged: (value) {
                          setState(() {
                            body7 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body7,
                        onChanged: (value) {
                          setState(() {
                            body7 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('clear of hot surfaces'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: body8,
                        onChanged: (value) {
                          setState(() {
                            body8 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: body8,
                        onChanged: (value) {
                          setState(() {
                            body8 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("CHEMICALS".toUpperCase(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('SDS available'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemical1,
                        onChanged: (value) {
                          setState(() {
                            chemical1 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: chemical1,
                        onChanged: (value) {
                          setState(() {
                            chemical1 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Chemicals are stored appropriately'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemical2,
                        onChanged: (value) {
                          setState(() {
                            chemical2 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: chemical2,
                        onChanged: (value) {
                          setState(() {
                            chemical2 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Contaminated rugs are disposed correctly'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemical3,
                        onChanged: (value) {
                          setState(() {
                            chemical3 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: chemical3,
                        onChanged: (value) {
                          setState(() {
                            chemical3 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Chemicals are stored appropriately'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemical4,
                        onChanged: (value) {
                          setState(() {
                            chemical4 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: chemical4,
                        onChanged: (value) {
                          setState(() {
                            chemical4 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("PROCEDURE".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('Established and understood'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: procedure1,
                        onChanged: (value) {
                          setState(() {
                            procedure1 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: procedure1,
                        onChanged: (value) {
                          setState(() {
                            procedure1 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Employee authorized to operate'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: procedure2,
                        onChanged: (value) {
                          setState(() {
                            procedure2 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: procedure2,
                        onChanged: (value) {
                          setState(() {
                            procedure2 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Maintained and followed'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: procedure3,
                        onChanged: (value) {
                          setState(() {
                            procedure3 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: procedure3,
                        onChanged: (value) {
                          setState(() {
                            procedure3 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Adequate for task'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: procedure4,
                        onChanged: (value) {
                          setState(() {
                            procedure4 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: procedure4,
                        onChanged: (value) {
                          setState(() {
                            procedure4 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("HOUSEKEEPING".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('Area is clear of obstructions'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: house1,
                        onChanged: (value) {
                          setState(() {
                            house1 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: house1,
                        onChanged: (value) {
                          setState(() {
                            house1 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Area is used for its intended purpose'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: house2,
                        onChanged: (value) {
                          setState(() {
                            house2 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: house2,
                        onChanged: (value) {
                          setState(() {
                            house2 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Materials is stored in safe Manner'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: house3,
                        onChanged: (value) {
                          setState(() {
                            house3 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: house3,
                        onChanged: (value) {
                          setState(() {
                            house3 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Uncover / Unbent nails'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: house4,
                        onChanged: (value) {
                          setState(() {
                            house4 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: house4,
                        onChanged: (value) {
                          setState(() {
                            house4 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Necessary Signs / Posters'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: house5,
                        onChanged: (value) {
                          setState(() {
                            house5 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: house5,
                        onChanged: (value) {
                          setState(() {
                            house5 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              Text("Tools and Equipment".toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('Selection of tools'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools1,
                        onChanged: (value) {
                          setState(() {
                            tools1 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools1,
                        onChanged: (value) {
                          setState(() {
                            tools1 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Proper use of tools/equipment'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools2,
                        onChanged: (value) {
                          setState(() {
                            tools2 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools2,
                        onChanged: (value) {
                          setState(() {
                            tools2 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Condition of tools/equipemnt'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools3,
                        onChanged: (value) {
                          setState(() {
                            tools3 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools3,
                        onChanged: (value) {
                          setState(() {
                            tools3 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Guards in place'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools4,
                        onChanged: (value) {
                          setState(() {
                            tools4 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools4,
                        onChanged: (value) {
                          setState(() {
                            tools4 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Safety latch in LG working well'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools5,
                        onChanged: (value) {
                          setState(() {
                            tools5 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools5,
                        onChanged: (value) {
                          setState(() {
                            tools5 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Equipment within calibration due dates'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools6,
                        onChanged: (value) {
                          setState(() {
                            tools6 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools6,
                        onChanged: (value) {
                          setState(() {
                            tools6 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                  const Text('Tools placed in position after use'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: tools7,
                        onChanged: (value) {
                          setState(() {
                            tools7 = value!;
                          });
                        },
                      ),
                      const Text("S"),
                      Radio(
                        value: "No",
                        groupValue: tools7,
                        onChanged: (value) {
                          setState(() {
                            tools7 = value!;
                          });
                        },
                      ),
                      const Text("AR"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              const SizedBox(height: 20,),
              const Text("Positive Observations (List 2) :", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              const Text("At Risk Behaviour / Improvement Required", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
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
              const Divider(thickness: 2,),
              const Text("Suggestions from employee to improve the At-risk behaviour", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
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
              const Text("Observers Feedback given to Employee", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
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
              const Divider(thickness: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const LPS(), // Replace NextPage with the actual name of your next page
                      //   ),
                      // );
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
