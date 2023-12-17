import 'package:flutter/material.dart';
import 'package:goltens_core/theme/theme.dart';
import 'LMA.dart';

class ConditionsForm extends StatefulWidget {
  const ConditionsForm({Key? key});

  @override
  State<ConditionsForm> createState() => _ConditionsFormState();
}

class _ConditionsFormState extends State<ConditionsForm> {
  String layoutGroupValue1 = "P";
  String layoutGroupValue2 = "P";
  String layoutGroupValue3 = "P";
  String flourGroupValue1 = "P";
  String flourGroupValue2 = "P";
  String flourGroupValue3 = "P";
  String flourGroupValue4 = "P";
  String toolsGroupValue1 = "P";
  String toolsGroupValue2 = "P";
  String toolsGroupValue3 = "P";
  String devicesGroupValue1 = "P";
  String devicesGroupValue2 = "P";
  String devicesGroupValue3 = "P";
  String devicesGroupValue4 = "P";
  String devicesGroupValue5 = "P";
  String ladderGroupValue = "P";
  String sGroupValue1 = "P";
  String sGroupValue2 = "P";
  String chemicalGroupValue1 = "P";
  String chemicalGroupValue2 = "P";
  String chemicalGroupValue3 = "P";
  String chemicalGroupValue4 = "P";
  String liftGroupValue1 = "P";
  String liftGroupValue2 = "P";
  String liftGroupValue3 = "P";
  String liftGroupValue4 = "P";
  String liftGroupValue5 = "P";
  String emergencyGroupValue1 = "P";
  String emergencyGroupValue2 = "P";
  String emergencyGroupValue3 = "P";
  String emergencyGroupValue4 = "P";
  String machineGroupValue1 = "P";
  String machineGroupValue2 = "P";
  String machineGroupValue3 = "P";
  String machineGroupValue4 = "P";
  String environmentGroupValue1 = "P";
  String environmentGroupValue2 = "P";
  String environmentGroupValue3 = "P";

  bool areAllConditionsMet() {
    return layoutGroupValue1 != "P" &&
        layoutGroupValue2 != "P" &&
        layoutGroupValue3 != "P" &&
        flourGroupValue1 != "P" &&
        flourGroupValue2 != "P" &&
        flourGroupValue3 != "P" &&
        flourGroupValue4 != "P" &&
        toolsGroupValue1 != "P" &&
        toolsGroupValue2 != "P" &&
        toolsGroupValue3 != "P" &&
        devicesGroupValue1 != "P" &&
        devicesGroupValue2 != "P" &&
        devicesGroupValue3 != "P" &&
        devicesGroupValue4 != "P" &&
        devicesGroupValue5 != "P" &&
        ladderGroupValue != "P" &&
        sGroupValue1 != "P" &&
        sGroupValue2 != "P" &&
        chemicalGroupValue1 != "P" &&
        chemicalGroupValue2 != "P" &&
        chemicalGroupValue3 != "P" &&
        chemicalGroupValue4 != "P" &&
        flourGroupValue1 != "P" &&
        flourGroupValue2 != "P" &&
        flourGroupValue3 != "P" &&
        flourGroupValue4 != "P" &&
        toolsGroupValue1 != "P" &&
        toolsGroupValue2 != "P" &&
        toolsGroupValue3 != "P" &&
        devicesGroupValue1 != "P" &&
        devicesGroupValue2 != "P" &&
        devicesGroupValue3 != "P" &&
        devicesGroupValue4 != "P" &&
        devicesGroupValue5 != "P" &&
        emergencyGroupValue1 != "P" &&
        emergencyGroupValue2 != "P" &&
        emergencyGroupValue3 != "P" &&
        emergencyGroupValue4 != "P" &&
        environmentGroupValue1 != "P" &&
        environmentGroupValue2 != "P" &&
        environmentGroupValue3 != "P";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conditions', style: TextStyle(color: Colors.black)),
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
              const Text("1. LAYOUT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('1.1 Check if there is enough space to walk around the machines, tools, and equipment'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: layoutGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            layoutGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: layoutGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            layoutGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('1.2 Check if there is light enough to perform the operation'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: layoutGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            layoutGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: layoutGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            layoutGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('1.3 Check if all relevant documents are available (SW, Checklist, etc.)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: layoutGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            layoutGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: layoutGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            layoutGroupValue3 = value!;
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
              const Text("2.FLOUR",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('2.1 Check if the floor is damaged or needs repair'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: flourGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: flourGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('2.2 Check if the floor level differences are properly identified (trip hazards)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: flourGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: flourGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('2.3 Check  if there are leaks/puddles on the floor (oil, water, grease, etc.))'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: flourGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: flourGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('2.4 Check if there are pits or man lifts without proper protection (fall risks)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: flourGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: flourGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            flourGroupValue4 = value!;
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
              const Text("3.TOOLS(Hand Tools)",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('3.1 Check if the tools are in good condition (not  broken, cracked, excessive abrasion)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: toolsGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            toolsGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: toolsGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            toolsGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('3.2 Check if hammers, drivers, or pins are in good condition with NO  "mushroom effect"'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: toolsGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            toolsGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: toolsGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            toolsGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('3.3 Check if the torque tools are in good condition and have reaction bars if required'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: toolsGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            toolsGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: toolsGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            toolsGroupValue3 = value!;
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
              const Text("4.LIFTING DEVICES",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('4.1 Check if cranes and hoist inspection tags have been completed'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: devicesGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: devicesGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('4.2 Check if the cranes and hoist buttons are functioning properly'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: devicesGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: devicesGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('4.3 Check if the lifting straps are still good to be used (slots, tears, etc...)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: devicesGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: devicesGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('4.4 Check if the magnets are clean and working , including the safe click'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: devicesGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: devicesGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('4.5 Check if the lifting devices have current inspection tags'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: devicesGroupValue5,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue5 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: devicesGroupValue5,
                        onChanged: (value) {
                          setState(() {
                            devicesGroupValue5 = value!;
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
              const Text("5.LADDER",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('5.1 Check if the ladders are in good condition (no corrosion, stability, etc...)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: ladderGroupValue,
                        onChanged: (value) {
                          setState(() {
                            ladderGroupValue = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: ladderGroupValue,
                        onChanged: (value) {
                          setState(() {
                            ladderGroupValue = value!;
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
              const Text("6.5S's",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('6.1 Check if the area is clean and well organized.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: sGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            sGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: sGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            sGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('6.2 Equipment and tools have the proper location defined and marked'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: sGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            sGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: sGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            sGroupValue2 = value!;
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
              const Text("7.CHEMICAL SUBSTANCES",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('7.1 Check if chemical products are properly packaged (packing, bottle)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemicalGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: chemicalGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('7.2 Check if chemical products are properly labeled'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemicalGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: chemicalGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('7.3 Check if chemical products are properly stored (containment basin / area)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemicalGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: chemicalGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('7.4 Check if chemical products instruction sheet are close and easy to access.'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: chemicalGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: chemicalGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            chemicalGroupValue4 = value!;
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
              const Text("8.FORKLIFT,EQUIPMENT(If Applicable",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('8.1 Check if the tires are good'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: liftGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: liftGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('8.2 Check if there is not leaks'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: liftGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: liftGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('8.3 Check if the safety items are working (seat belt, horn, light, etc.)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: liftGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: liftGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('8.4 Check if the check list is fulfilled before start the activities'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: liftGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: liftGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text("8.5 Check if the battery's lock is working safely"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: liftGroupValue5,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue5 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: liftGroupValue5,
                        onChanged: (value) {
                          setState(() {
                            liftGroupValue5 = value!;
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
              const Text("9.EMERGENCY EQUIPMENT",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('9.1 Check if the fire extinguisher have current inspection'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: emergencyGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: emergencyGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('9.2 Check if emergency or medical  equipment identified (if applicable)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: emergencyGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: emergencyGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('9.3 Check if the area has emergency light / alarm'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: emergencyGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: emergencyGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('9.4 Check if the eye wash is working  (if applicable)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: emergencyGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: emergencyGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            emergencyGroupValue4 = value!;
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
              const Text("10.MACHINE CENTERS(If Applicable)",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('10.1 Check if the machines have protection guards in place'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: machineGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: machineGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('10.2 Check if the machines have redundant protection systems'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: machineGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: machineGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('10.3 Check if the emergency items are in place and active'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: machineGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: machineGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('10.4 Check if the ergonomic improvements are being used'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: machineGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue4 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: machineGroupValue4,
                        onChanged: (value) {
                          setState(() {
                            machineGroupValue4 = value!;
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
              const Text("11.ENVIRONMENT",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              const SizedBox(height: 20,),
              Column(
                children: [
                  const Text('11.1 Check if the  trash and waste collectors are identified'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: environmentGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            environmentGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: environmentGroupValue1,
                        onChanged: (value) {
                          setState(() {
                            environmentGroupValue1 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('11.2 Check if the waste are segregated correctly'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: environmentGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            environmentGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: environmentGroupValue2,
                        onChanged: (value) {
                          setState(() {
                            environmentGroupValue2 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                  const Text('11.3 Check if the waste is place correctly (empty box unassembled, etc.)'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: "Yes",
                        groupValue: environmentGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            environmentGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("Yes"),
                      Radio(
                        value: "No",
                        groupValue: environmentGroupValue3,
                        onChanged: (value) {
                          setState(() {
                            environmentGroupValue3 = value!;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ],
              ),
              const Divider(thickness: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LMA(), // Replace LMA with the actual name of your next page
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
