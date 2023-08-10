// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutterdemo/Model/questionModelForMaster.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   MyHomePageState createState() => MyHomePageState();
// }
//
// class MyHomePageState extends State<MyHomePage> {
//   int currentMainIndex = 0;
//   int currentIndex = 0;
//
//
//   int subFlowPreLength = 0;
//   ///ASSIGNED TO EVERY ELEMENT
//   String previousMainId = "";
//
//   ///WILL BE ASSIGNED TO START ELEMENT AND WILL BE CHECKED FOR SAME
//   String previousFlowId = "";
//
//   List<Elements> masterFlow = [];
//   List<Elements> subFlow = [];
//   bool isMasterFlowActive = true;
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   List<FlowMain> flowsData = [];
//
//   TextEditingController answerController = TextEditingController();
//
//   double age = 25.00;
//   String gender = "male";
//
//   bool skipping = false;
//   String preId = "";
//   String previousSubId = "";
//
//   @override
//   void initState() {
//     getFlows();
//     super.initState();
//   }
//
//   getFlows() async {
//     try {
//       QuerySnapshot<Map<String, dynamic>> res = await firebaseFirestore
//           .collection('Testing')
//           .get();
//
//       flowsData = questionsMainFromJson(res.docs);
//
//       String? id;
//
//       for (FlowMain data in flowsData) {
//         if (data.priority == 0) {
//           setState(() {
//             id = data.flowId;
//           });
//         }
//       }
//
//       if (id != null) {
//         ///INITIALIZE THE VALUE FOR PREVIOUS FLOW ID WHICH WILL BE MASTER FLOW ID AT START EVERYTIME
//         // setState(() {
//         // //previousFlowId = id ?? "";
//         // });
//         getMasterFlow(id!);
//       } else {
//         if (kDebugMode) {
//           print("No document with priority value 0 found.");
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print("THIS IS ERROR $e");
//       }
//     }
//   }
//
//   getMasterFlow(String id) async {
//     try {
//       if (flowsData.isNotEmpty) {
//         FlowMain document = flowsData.firstWhere((data) => data.flowId == id);
//
//         setState(() {
//           masterFlow = document.elements ?? [];
//           previousMainId=masterFlow[currentMainIndex].id;
//           masterFlow[currentMainIndex].previousId=previousMainId;
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   /// GET SUB FLOW DATA WHICH WILL BE OPENED WHEN NAVIGATION ID WILL BE PROVIDED BY MASTERFLOW
//   getSubFlow(String id) {
//     try {
//       FlowMain? document = flowsData.firstWhere(
//             (data) => data.flowId == id,
//       );
//       setState(() {
//         subFlow = document.elements ?? [];
//
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   ///WHEN SUBFLOW IS NOT EMPTY AND WE NAVIGATE TO ANOTHER SUBFLOW FROM EXISTING SUBFLOW
//   addSubFlow(String id){
//     try {
//       FlowMain? document = flowsData.firstWhere(
//             (data) => data.flowId == id,
//       );
//       setState(() {
//         print("subflow before : $subFlow");
//         subFlow.insertAll(currentIndex+1, document.elements!);
//         print("subflow after : $subFlow");
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   ///WHEN SUBFLOW IS NOT EMPTY AND WE NAVIGATE TO ANOTHER SUBFLOW FROM MAIN FLOW
//   addSubFlowByMain(String id){
//     try {
//       FlowMain? document = flowsData.firstWhere(
//             (data) => data.flowId == id,
//       );
//       setState(() {
//         print("subflow before : $subFlow");
//         subFlowPreLength = subFlow.length;
//
//         subFlow.insertAll(subFlow.length, document.elements!);
//
//
//         print("subflow after : $subFlow");
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   incrementForMainFlow() {
//     ///LOGIC FOR MASTER FLOW LIST
//
//     setState(() {
//       previousMainId = masterFlow[currentMainIndex].id;
//     });
//
//
//     if (masterFlow[currentMainIndex].kind == 1) {
//       ///IF ANSWER IS YES
//       if (answerController.value.text == "1") {
//         setState(() {
//           currentMainIndex = getMainIndexById(
//               masterFlow[currentMainIndex].next![0].destElementId!);
//           masterFlow[currentMainIndex].previousId = previousMainId;
//         });
//       }
//
//       ///IF ANSWER IS NO
//       if (answerController.value.text == "0") {
//         setState(() {
//           currentMainIndex = getMainIndexById(
//               masterFlow[currentMainIndex].next![1].destElementId!);
//           masterFlow[currentMainIndex].previousId = previousMainId;
//         });
//       }
//
//       return;
//     }
//
//     ///ELEMENT TO JUMP TO OTHER FLOW WHEN KIND 3 COMES
//     if (masterFlow[currentMainIndex].kind == 7) {
//
//       ///IF SUBFLOW LIST IS EMPTY
//       if(subFlow.isEmpty) {
//         getSubFlow(masterFlow[currentMainIndex].navigationId!);
//         setState(() {
//           int y=currentMainIndex;
//           currentMainIndex = getMainIndexById(masterFlow[currentMainIndex].next![0].destElementId!);
//           masterFlow[currentMainIndex].previousId = masterFlow[y].endId;
//           subFlow[currentIndex].previousId = masterFlow[y].id;
//           isMasterFlowActive = false;
//         });
//       }
//       ///IF ANY SUBFLOW HAS ALREADY BEEN NAVIGATED TO, AND SUBFLOW IS NOT EMPTY
//       else{
//         int x=subFlow.length;
//         addSubFlowByMain(masterFlow[currentMainIndex].navigationId!);
//         setState(() {
//           currentIndex=x;
//           currentMainIndex = getMainIndexById(masterFlow[currentMainIndex].next![0].destElementId!);
//           masterFlow[currentMainIndex].previousId = previousMainId;
//           subFlow[currentIndex].previousId = previousMainId;
//           isMasterFlowActive = false;
//         });
//       }
//       return;
//     }
//
//     ///FOR START
//     if (masterFlow[currentMainIndex].kind == 3 ) {
//       setState(() {
//         currentMainIndex = getMainIndexById(masterFlow[currentMainIndex].next![0].destElementId!);
//         masterFlow[currentMainIndex].previousId = previousMainId;
//       });
//
//       return;
//     }
//
//     ///LOGIC ENDS FOR MASTER FLOW LIST INCREMENT
//   }
//
//
//
//   incrementForSubFlow() {
//     print ("condition : ${subFlow[currentIndex].text}_${checkCondition()}");
//     print("skipping : ${subFlow[currentIndex].text}_${skipping}");
//     print("preid : $preId");
//
//     checkCondition();
//     ///LOGIC STARTS FOR SUB-FLOW LIST INCREMENT
//     setState(() {
//       subFlow[currentIndex].answer = answerController.value.text;
//       previousMainId=subFlow[currentIndex].id;
//     });
//     ///FOR NORMAL QUESTION
//     if (subFlow[currentIndex].kind == 0) {
//       if(skipping == false){
//         setState(() {
//           previousSubId = subFlow[currentIndex].id;
//         });
//       }
//       setState(() {
//         currentIndex = getSubIndexById(subFlow[currentIndex].next![0].destElementId!);
//         subFlow[currentIndex].previousId = preId;
//       });
//
//       if(checkCondition()==true){
//         if(skipping == false){
//           setState(() {
//             preId = previousSubId;
//             subFlow[currentIndex].previousId=preId;
//             // skipping = false;
//           });
//         }
//         if(skipping==true){
//           setState(() {
//             skipping=false;
//             // preId = subFlow[currentIndex].id;
//           });
//         }
//       }
//       else{
//         setState(() {
//           skipping = true;
//           preId = previousSubId;
//         });
//         incrementForSubFlow();
//       }
//       return;
//     }
//
//
//     ///FOR CONDITIONAL QUESTION
//     if (subFlow[currentIndex].kind == 1) {
//       if(skipping == false){
//         setState(() {
//           previousSubId = subFlow[currentIndex].id;
//         });
//       }
//       ///IF ANSWER IS YES
//       if (answerController.value.text == "1") {
//
//         setState(() {
//           currentIndex = getSubIndexById(subFlow[currentIndex].next![0].destElementId!);
//           subFlow[currentIndex].previousId=preId;
//         });
//         if(checkCondition()==true){
//           if(skipping == false){
//             setState(() {
//               preId = previousSubId;
//               subFlow[currentIndex].previousId=preId;
//               // skipping = false;
//             });
//           }
//           if(skipping==true){
//             setState(() {
//               skipping=false;
//               // preId = subFlow[currentIndex].id;
//             });
//           }
//         }
//         else{
//           setState(() {
//             skipping = true;
//             preId = previousSubId;
//           });
//           incrementForSubFlow();
//         }
//         return;
//       }
//
//       ///IF ANSWER IS NO
//       if (answerController.value.text == "0") {
//         setState(() {
//           currentIndex = getSubIndexById(subFlow[currentIndex].next![1].destElementId!);
//           subFlow[currentIndex].previousId=preId;
//         });
//         if(checkCondition()==true){
//           if(skipping == false){
//             setState(() {
//               preId = previousSubId;
//               subFlow[currentIndex].previousId=preId;
//               // skipping = false;
//             });
//           }
//           if(skipping==true){
//             setState(() {
//               skipping=false;
//               // preId = subFlow[currentIndex].id;
//             });
//           }
//         }
//         else{
//           setState(() {
//             skipping = true;
//             preId = previousSubId;
//           });
//           incrementForSubFlow();
//         }
//       }
//       return;
//     }
//
//     ///FOR MOVING TO ANOTHER SUB FLOW
//     if (subFlow[currentIndex].kind == 7) {
//       if(skipping == false){
//         setState(() {
//           previousSubId = subFlow[currentIndex].id;
//         });
//       }
//       addSubFlow(subFlow[currentIndex].navigationId!);
//       setState(() {
//         int goBack = getSubIndexById(subFlow[currentIndex].endId!);
//         subFlow[goBack].prevSubFlowQuestion=subFlow[currentIndex].next![0].destElementId;
//         currentIndex=getSubIndexById(subFlow[currentIndex].startId!);
//         subFlow[currentIndex].previousId=preId;
//       });
//       if(checkCondition()==true){
//         if(skipping == false){
//           setState(() {
//             preId = previousSubId;
//             subFlow[currentIndex].previousId=preId;
//             // skipping = false;
//           });
//         }
//         if(skipping==true){
//           setState(() {
//             skipping=false;
//             // preId = subFlow[currentIndex].id;
//           });
//         }
//       }
//       else{
//         setState(() {
//           skipping = true;
//           preId = previousSubId;
//         });
//         incrementForSubFlow();
//       }
//       return;
//     }
//
//
//
//
//     ///FOR START
//     if (subFlow[currentIndex].kind == 3 ) {
//       if(skipping == false){
//         setState(() {
//           previousSubId = subFlow[currentIndex].id;
//         });
//       }
//       setState(() {
//         currentIndex = getSubIndexById(subFlow[currentIndex].next![0].destElementId!);
//         subFlow[currentIndex].previousId = preId;
//       });
//       if(checkCondition()==true){
//         if(skipping == false){
//           setState(() {
//             preId = previousSubId;
//             subFlow[currentIndex].previousId=preId;
//             // skipping = false;
//           });
//         }
//         if(skipping==true){
//           setState(() {
//             skipping=false;
//             // preId = subFlow[currentIndex].id;
//           });
//         }
//       }
//       else{
//         setState(() {
//           skipping = true;
//           preId = previousSubId;
//         });
//         incrementForSubFlow();
//       }
//       return;
//     }
//
//     ///FOR END
//     if (subFlow[currentIndex].kind == 4 ) {
//
//       if(skipping == false){
//         setState(() {
//           previousSubId = subFlow[currentIndex].id;
//         });
//       }
//
//       if(subFlow[currentIndex].prevSubFlowQuestion==null || subFlow[currentIndex].prevSubFlowQuestion.isEmpty)
//       {
//         setState(() {
//
//           isMasterFlowActive = true;
//           subFlow[currentIndex].previousId=preId;
//
//         });
//         if(isMasterFlowActive == true){
//           setState(() {
//             currentIndex = subFlow.length;
//           });
//         }
//         if(checkCondition()==true){
//           if(skipping == false){
//             setState(() {
//               preId = previousSubId;
//               subFlow[currentIndex].previousId=preId;
//               // skipping = false;
//             });
//           }
//           if(skipping==true){
//             setState(() {
//               skipping=false;
//               // preId = subFlow[currentIndex].id;
//             });
//           }
//         }
//         else{
//           setState(() {
//             skipping = true;
//             preId = previousSubId;
//           });
//           incrementForSubFlow();
//         }
//       }
//       else{
//         setState(() {
//           currentIndex=getSubIndexById(subFlow[currentIndex].prevSubFlowQuestion);
//           subFlow[currentIndex].previousId=preId;
//         });
//         if(checkCondition()==true){
//           if(skipping == false){
//             setState(() {
//               preId = previousSubId;
//               subFlow[currentIndex].previousId=preId;
//               // skipping = false;
//             });
//           }
//           if(skipping==true){
//             setState(() {
//               skipping=false;
//               // preId = subFlow[currentIndex].id;
//             });
//           }
//         }
//         else{
//           setState(() {
//             skipping = true;
//             preId = previousSubId;
//           });
//           incrementForSubFlow();
//         }
//       }
//       return;
//     }
//     ///LOGIC ENDS FOR SUB-FLOW LIST INCREMENT
//   }
//
//
//   decrementForMainFlow(){
//
//     // print("currentMainIndex before decrementing : $currentMainIndex ${masterFlow[currentMainIndex].previousId} ");
//     // print("length ${subFlow.length}");
//
//     if(subFlow.isNotEmpty ){
//       setState(() {
//         masterFlow[currentMainIndex].previousId = subFlow.last.id;
//         currentIndex = getSubIndexById(masterFlow[currentMainIndex].previousId);
//         isMasterFlowActive = false;
//       });
//     }
//     else{
//       setState(() {
//         currentMainIndex=getMainIndexById(masterFlow[currentMainIndex].previousId);
//       });
//     }
//     print("currentIndex after decrementing : $currentIndex");
//     print("currentMainIndex after decrementing : $currentMainIndex");
//
//   }
//
//
//   decrementForSubFlow(){
//     ///IF WE REACH THE FIRST SUBFLOW'S FIRST QUESTION WE SHOULD BE MOVING BACK TO MASTER FLOW
//
//     // if(subFlow.isNotEmpty && subFlow[currentIndex].kind == 3 && isMasterFlowActive == false){
//     //   print("hiiiii");
//     //   int Id = getMainIndexById(masterFlow[currentMainIndex-2].id);
//     //
//     //   print("This is id : ${Id} and text ${masterFlow[Id].text}");
//     //
//     //   subFlow[currentIndex].previousId = masterFlow[Id].id;
//     //
//     //   print("this is ${subFlow[currentIndex].previousId} and text is ${subFlow[currentIndex].text}");
//     //   isMasterFlowActive = true;
//     //   if(isMasterFlowActive == true){
//     //     currentMainIndex = currentMainIndex-2;
//     //   }
//     //
//     // }
//     if(currentIndex==0){
//       setState(() {
//         isMasterFlowActive=true;
//         currentMainIndex = getMainIndexById(subFlow[currentIndex].previousId);
//         ///CLEAR SUB FLOW LIST, SO WE CAN MOVE AGAIN ACROSS FLOWCHARTS subFlow.clear()
//
//         subFlow = [];
//         print("subflow : ${subFlow}");
//       });
//     }
//     if(subFlow.isNotEmpty && subFlow[currentIndex].kind == 3){
//       print("sub flow length ${subFlow.length}");
//       subFlow.removeRange(subFlowPreLength, subFlow.length-1);
//       setState(() {
//         subFlowPreLength = subFlow.length;
//       });
//       print("sub flow length ${subFlow.length}");
//     }
//     else {
//       setState(() {
//         print("${subFlow[currentIndex].text} _____${subFlow[currentIndex].previousId}");
//         currentIndex = getSubIndexById(subFlow[currentIndex].previousId);
//         print("${subFlow[currentIndex].text} _____${subFlow[currentIndex].previousId}");
//         print("currentIndex sub flow $currentIndex");
//       });
//     }
//   }
//
//   int getMainIndexById(String id) {
//     for (int i = 0; i < masterFlow.length; i++) {
//       if (masterFlow[i].id == id) {
//         return i;
//       }
//     }
//     return currentMainIndex-1;
//
//   }
//
//   int getSubIndexById(String id) {
//     for (int i = 0; i < subFlow.length; i++) {
//       if (subFlow[i].id == id) {
//         return i;
//       }
//     }
//     return currentIndex-1;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             masterFlow.isNotEmpty
//                 ? isMasterFlowActive
//                 ? Text("TEXT : ${masterFlow[currentMainIndex].text}")
//                 : Text("Text : ${subFlow[currentIndex].text}")
//                 : const Text(""),
//             SizedBox(
//               width: 100,
//               child: TextField(
//                 controller: answerController,
//                 // onSubmitted: (_) async {
//                 //   isMasterFlowActive
//                 //       ? await incrementForMainFlow()
//                 //       : await incrementForSubFlow();
//                 // },
//                 decoration: const InputDecoration(hintText: "ANSWER"),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 10,),
//
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(onPressed:() => isMasterFlowActive
//                     ?decrementForMainFlow():decrementForSubFlow(),
//                     child: const Icon(Icons.arrow_back)),
//
//                 const SizedBox(
//                   height: 10,
//                 ),
//
//                 ElevatedButton(onPressed:() => isMasterFlowActive
//                     ?  incrementForMainFlow()
//                     : incrementForSubFlow(),
//                     child: const Icon(Icons.arrow_forward)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool checkCondition() {
//     bool ageMet = false;
//     bool genderMet = false;
//     bool showQues = false;
//     print("in check condition");
//     // print("length ${subFlow[currentIndex].ageGroup.length}");
//     for (int i = 0; i < subFlow[currentIndex].ageGroup.length; i++) {
//       print("in check condition1");
//       if ((age >= subFlow[currentIndex].ageGroup[i].start) &&
//           (age <= subFlow[currentIndex].ageGroup[i].end)) {
//         print("in check condition2");
//         setState(() {
//           ageMet = true;
//           print("in check condition3");
//         });
//       }
//     }
//     for (int i = 0; i < subFlow[currentIndex].genderGroup.length; i++) {
//       print("in check condition4");
//       if (subFlow[currentIndex].genderGroup[i] == gender) {
//         print("in check condition5");
//         setState(() {
//           genderMet = true;
//           print("in check condition6");
//         });
//       }
//     }
//
//     if (ageMet == true && genderMet == true) {
//       print("in check condition7");
//       setState(() {
//         showQues = true;
//         print("in check condition8");
//       });
//     }
//     print("in check condition9");
//     return showQues;
//   }
//
// }