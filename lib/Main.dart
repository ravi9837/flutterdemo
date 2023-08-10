import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/View/QuestionScreen.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(FlowController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QuestionPage(),
    );
  }
}














//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//
//   @override
//   MyHomePageState createState() => MyHomePageState();
// }
//
// class MyHomePageState extends State<MyHomePage> {
//   // int currentMainIndex = 0;
//   // int currentIndex = 0;
//   //
//   //
//   // int subFlowPreLength = 0;
//   // ///ASSIGNED TO EVERY ELEMENT
//   // String previousMainId = "";
//   //
//   // ///WILL BE ASSIGNED TO START ELEMENT AND WILL BE CHECKED FOR SAME
//   // String previousFlowId = "";
//   //
//   // List<StartEndIndex> startEndIndex = [];
//   //
//   // List<Elements> masterFlow = [];
//   // // List<Elements> subFlow = [];
//   // // bool isMasterFlowActive = true;
//   // FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   // List<FlowMain> flowsData = [];
//   //
//   // TextEditingController answerController = TextEditingController();
//   //
//   //
//   // double age = 18.0;
//   // String gender = "female";
//   //
//   // bool skipping = false;
//   // String preId = "";
//   // String previousSkipId = "";
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
//       // print("flowsData is this ${flowsData}");
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
//         // subFlow = document.elements ?? [];
//         // print("master flow befor ${masterFlow}");
//         printFlow();
//         masterFlow.insertAll(currentMainIndex+1, document.elements!);
//         printFlow();
//         // print("master flow after ${masterFlow}");
//
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   printFlow(){
//     for(int i = 0 ; i < masterFlow.length; i++){
//       print(masterFlow[i].text);
//     }
//   }
//
//   // ///WHEN SUBFLOW IS NOT EMPTY AND WE NAVIGATE TO ANOTHER SUBFLOW FROM EXISTING SUBFLOW
//   // addSubFlow(String id){
//   //   try {
//   //     FlowMain? document = flowsData.firstWhere(
//   //           (data) => data.flowId == id,
//   //     );
//   //     setState(() {
//   //       print("subflow before : $subFlow");
//   //       subFlow.insertAll(currentIndex+1, document.elements!);
//   //       print("subflow after : $subFlow");
//   //     });
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print(e);
//   //     }
//   //   }
//   // }
//
//   // ///WHEN SUBFLOW IS NOT EMPTY AND WE NAVIGATE TO ANOTHER SUBFLOW FROM MAIN FLOW
//   // addSubFlowByMain(String id){
//   //   try {
//   //     FlowMain? document = flowsData.firstWhere(
//   //           (data) => data.flowId == id,
//   //     );
//   //     setState(() {
//   //       print("subflow before : $subFlow");
//   //
//   //       subFlowPreLength = subFlow.length;
//   //
//   //       subFlow.insertAll(subFlow.length, document.elements!);
//   //
//   //       print("subflow after : $subFlow");
//   //
//   //     });
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print(e);
//   //     }
//   //   }
//   // }
//
//   ///ADDS ERRORS AMD THE SECOND WHEN THE ERROR COMES TO THE ERROR LIST
//   addIndex({required int start, required int end}) {
//     try {
//       StartEndIndex index = StartEndIndex(
//           start: start,
//           end: end);
//       startEndIndex.add(index);
//       print("startEndIndex ${jsonEncode(startEndIndex)}");
//       return startEndIndex;
//     } catch (error) {
//       debugPrint(" 1 FAILED TO LOG THE ERROR TO DB");
//     }
//   }
//
//
//   ///TAKING AGE INPUT FROM THE USER
//   enterAge(){
//     if(masterFlow[currentMainIndex].text == "Age in Years"){
//       print("age before ${age}");
//       setState(() {
//         age = double.tryParse(masterFlow[currentMainIndex].answer)!;
//       });
//       print("age after ${age}");
//     }
//   }
//
//
//   ///TAKING GENDER INPUT FROM THE USER
//   enterGender(){
//     if(masterFlow[currentMainIndex].text == "Gender"){
//       print("gender before ${gender}");
//       setState(() {
//         gender = masterFlow[currentMainIndex].answer;
//       });
//       print("gender before ${gender}");
//     }
//   }
//
//
//   checkAnswerAvailable(){
//     try{
//       if(masterFlow[currentMainIndex].answer != "" || masterFlow[currentMainIndex].answer != null){
//         setState(() {
//           answerController.text = masterFlow[currentMainIndex].answer;
//         });
//       }
//     }catch(e){
//       print("got an error ${e}");
//     }
//   }
//
//
//   incrementForMainFlow() {
//     ///LOGIC FOR MASTER FLOW LIST
//     setState(() {
//       previousMainId = masterFlow[currentMainIndex].id;
//       masterFlow[currentMainIndex].answer = answerController.text;
//     });
//
//     if (masterFlow[currentMainIndex].kind == 4 &&
//         currentMainIndex != masterFlow.length - 1) {
//       if (skipping == false) {
//         setState(() {
//           previousSkipId = masterFlow[currentMainIndex].id;
//         });
//       }
//       setState(() {
//         for(int v=0;v<masterFlow.length;v++){
//           if(masterFlow[v].endId==masterFlow[currentMainIndex].id){
//             setState(() {
//               currentMainIndex = getMainIndexById(masterFlow[v].next![0].destElementId!);
//               answerController.clear();
//               checkAnswerAvailable();
//             });
//           }
//         }
//         masterFlow[currentMainIndex].previousId = preId;
//       });
//       if (checkCondition() == true) {
//         if (skipping == false) {
//           setState(() {
//             preId = previousSkipId;
//             masterFlow[currentMainIndex].previousId = preId;
//           });
//         }
//         if (skipping == true) {
//           setState(() {
//             skipping = false;
//           });
//         }
//       } else {
//         setState(() {
//           skipping = true;
//           preId = previousSkipId;
//         });
//         incrementForMainFlow();
//       }
//       return;
//     }
//
//     ///FOR START
//     if (masterFlow[currentMainIndex].kind == 3) {
//       if (skipping == false) {
//         setState(() {
//           previousSkipId = masterFlow[currentMainIndex].id;
//         });
//       }
//       setState(() {
//         currentMainIndex = getMainIndexById(
//             masterFlow[currentMainIndex].next![0].destElementId!);
//         masterFlow[currentMainIndex].previousId = preId;
//         answerController.clear();
//         checkAnswerAvailable();
//       });
//       if (checkCondition() == true) {
//         if (skipping == false) {
//           setState(() {
//             preId = previousSkipId;
//             masterFlow[currentMainIndex].previousId = preId;
//           });
//         }
//         if (skipping == true) {
//           setState(() {
//             skipping = false;
//           });
//         }
//       } else {
//         setState(() {
//           skipping = true;
//           preId = previousSkipId;
//         });
//         incrementForMainFlow();
//       }
//       return;
//     }
//
//
//     if (masterFlow[currentMainIndex].kind == 7) {
//       getSubFlow(masterFlow[currentMainIndex].navigationId);
//       if (skipping == false) {
//         setState(() {
//           previousSkipId = masterFlow[currentMainIndex].id;
//         });
//       }
//       setState(() {
//         ///ADDING THE START AND THE END INDEX OF THE SUB FLOW TO THE LIST
//         addIndex(start: getMainIndexById(masterFlow[currentMainIndex].startId),
//             end: getMainIndexById(masterFlow[currentMainIndex].endId));
//
//         currentMainIndex =
//             getMainIndexById(masterFlow[currentMainIndex].startId);
//         masterFlow[currentMainIndex].previousId = preId;
//         answerController.clear();
//         checkAnswerAvailable();
//
//       });
//       if (checkCondition() == true) {
//         if (skipping == false) {
//           setState(() {
//             preId = previousSkipId;
//             masterFlow[currentMainIndex].previousId = preId;
//           });
//         }
//         if (skipping == true) {
//           setState(() {
//             skipping = false;
//           });
//         }
//       } else {
//         setState(() {
//           skipping = true;
//           preId = previousSkipId;
//         });
//         incrementForMainFlow();
//       }
//       return;
//     }
//
//
//     if (masterFlow[currentMainIndex].kind == 1) {
//       if (skipping == false) {
//         setState(() {
//           previousSkipId = masterFlow[currentMainIndex].id;
//         });
//       }
//
//       ///IF ANSWER IS YES
//       if (answerController.value.text == "1") {
//         setState(() {
//           currentMainIndex = getMainIndexById(
//               masterFlow[currentMainIndex].next![0].destElementId!);
//           masterFlow[currentMainIndex].previousId = preId;
//           answerController.clear();
//           checkAnswerAvailable();
//
//         });
//         if (checkCondition() == true) {
//           if (skipping == false) {
//             setState(() {
//               preId = previousSkipId;
//               masterFlow[currentMainIndex].previousId = preId;
//             });
//           }
//           if (skipping == true) {
//             setState(() {
//               skipping = false;
//             });
//           }
//         } else {
//           setState(() {
//             skipping = true;
//             preId = previousSkipId;
//           });
//           incrementForMainFlow();
//         }
//         return;
//       }
//
//       ///IF ANSWER IS NO
//       if (answerController.value.text == "0") {
//         setState(() {
//           currentMainIndex = getMainIndexById(
//               masterFlow[currentMainIndex].next![1].destElementId!);
//           masterFlow[currentMainIndex].previousId = preId;
//           answerController.clear();
//           checkAnswerAvailable();
//
//         });
//         if (checkCondition() == true) {
//           if (skipping == false) {
//             setState(() {
//               preId = previousSkipId;
//               masterFlow[currentMainIndex].previousId = preId;
//             });
//           }
//           if (skipping == true) {
//             setState(() {
//               skipping = false;
//             });
//           }
//         } else {
//           setState(() {
//             skipping = true;
//             preId = previousSkipId;
//           });
//           incrementForMainFlow();
//         }
//         return;
//       }
//     }
//
//
//     if (masterFlow[currentMainIndex].kind == 0) {
//
//       enterAge();
//       enterGender();
//
//       if (skipping == false) {
//         setState(() {
//           previousSkipId = masterFlow[currentMainIndex].id;
//         });
//       }
//       setState(() {
//         currentMainIndex = getMainIndexById(
//             masterFlow[currentMainIndex].next![0].destElementId!);
//         masterFlow[currentMainIndex].previousId = preId;
//         answerController.clear();
//         checkAnswerAvailable();
//
//       });
//
//       if (checkCondition() == true) {
//         if (skipping == false) {
//           setState(() {
//             preId = previousSkipId;
//             masterFlow[currentMainIndex].previousId = preId;
//           });
//         }
//         if (skipping == true) {
//           setState(() {
//             skipping = false;
//           });
//         }
//       } else {
//         setState(() {
//           skipping = true;
//           preId = previousSkipId;
//         });
//         incrementForMainFlow();
//       }
//       return;
//     }
//   }
//
//
//
//
//     // incrementForSubFlow() {
//   //   print ("condition : ${subFlow[currentIndex].text}_${checkCondition()}");
//   //   print("skipping : ${subFlow[currentIndex].text}_${skipping}");
//   //   print("preid : $preId");
//   //
//   //   checkCondition();
//   //   ///LOGIC STARTS FOR SUB-FLOW LIST INCREMENT
//   //   setState(() {
//   //     subFlow[currentIndex].answer = answerController.value.text;
//   //     previousMainId=subFlow[currentIndex].id;
//   //   });
//   //   ///FOR NORMAL QUESTION
//   //   if (subFlow[currentIndex].kind == 0) {
//   //     if(skipping == false){
//   //       setState(() {
//   //         previousSubId = subFlow[currentIndex].id;
//   //       });
//   //     }
//   //     setState(() {
//   //       currentIndex = getSubIndexById(subFlow[currentIndex].next![0].destElementId!);
//   //       subFlow[currentIndex].previousId = preId;
//   //     });
//   //
//   //     if(checkCondition()==true){
//   //       if(skipping == false){
//   //         setState(() {
//   //           preId = previousSubId;
//   //           subFlow[currentIndex].previousId=preId;
//   //           // skipping = false;
//   //         });
//   //       }
//   //       if(skipping==true){
//   //         setState(() {
//   //           skipping=false;
//   //           // preId = subFlow[currentIndex].id;
//   //         });
//   //       }
//   //     }
//   //     else{
//   //       setState(() {
//   //         skipping = true;
//   //         preId = previousSubId;
//   //       });
//   //       incrementForSubFlow();
//   //     }
//   //     return;
//   //   }
//   //
//   //
//   //   ///FOR CONDITIONAL QUESTION
//   //   if (subFlow[currentIndex].kind == 1) {
//   //     if(skipping == false){
//   //       setState(() {
//   //         previousSubId = subFlow[currentIndex].id;
//   //       });
//   //     }
//   //     ///IF ANSWER IS YES
//   //     if (answerController.value.text == "1") {
//   //
//   //       setState(() {
//   //         currentIndex = getSubIndexById(subFlow[currentIndex].next![0].destElementId!);
//   //         subFlow[currentIndex].previousId=preId;
//   //       });
//   //       if(checkCondition()==true){
//   //         if(skipping == false){
//   //           setState(() {
//   //             preId = previousSubId;
//   //             subFlow[currentIndex].previousId=preId;
//   //             // skipping = false;
//   //           });
//   //         }
//   //         if(skipping==true){
//   //           setState(() {
//   //             skipping=false;
//   //             // preId = subFlow[currentIndex].id;
//   //           });
//   //         }
//   //       }
//   //       else{
//   //         setState(() {
//   //           skipping = true;
//   //           preId = previousSubId;
//   //         });
//   //         incrementForSubFlow();
//   //       }
//   //       return;
//   //     }
//   //
//   //     ///IF ANSWER IS NO
//   //     if (answerController.value.text == "0") {
//   //       setState(() {
//   //         currentIndex = getSubIndexById(subFlow[currentIndex].next![1].destElementId!);
//   //         subFlow[currentIndex].previousId=preId;
//   //       });
//   //       if(checkCondition()==true){
//   //         if(skipping == false){
//   //           setState(() {
//   //             preId = previousSubId;
//   //             subFlow[currentIndex].previousId=preId;
//   //             // skipping = false;
//   //           });
//   //         }
//   //         if(skipping==true){
//   //           setState(() {
//   //             skipping=false;
//   //             // preId = subFlow[currentIndex].id;
//   //           });
//   //         }
//   //       }
//   //       else{
//   //         setState(() {
//   //           skipping = true;
//   //           preId = previousSubId;
//   //         });
//   //         incrementForSubFlow();
//   //       }
//   //     }
//   //     return;
//   //   }
//   //
//   //   ///FOR MOVING TO ANOTHER SUB FLOW
//   //   if (subFlow[currentIndex].kind == 7) {
//   //     if(skipping == false){
//   //       setState(() {
//   //         previousSubId = subFlow[currentIndex].id;
//   //       });
//   //     }
//   //     addSubFlow(subFlow[currentIndex].navigationId!);
//   //     setState(() {
//   //       int goBack = getSubIndexById(subFlow[currentIndex].endId!);
//   //       subFlow[goBack].prevSubFlowQuestion=subFlow[currentIndex].next![0].destElementId;
//   //       currentIndex=getSubIndexById(subFlow[currentIndex].startId!);
//   //       subFlow[currentIndex].previousId=preId;
//   //     });
//   //     if(checkCondition()==true){
//   //       if(skipping == false){
//   //         setState(() {
//   //           preId = previousSubId;
//   //           subFlow[currentIndex].previousId=preId;
//   //           // skipping = false;
//   //         });
//   //       }
//   //       if(skipping==true){
//   //         setState(() {
//   //           skipping=false;
//   //           // preId = subFlow[currentIndex].id;
//   //         });
//   //       }
//   //     }
//   //     else{
//   //       setState(() {
//   //         skipping = true;
//   //         preId = previousSubId;
//   //       });
//   //       incrementForSubFlow();
//   //     }
//   //     return;
//   //   }
//   //
//   //
//   //
//   //
//   //   ///FOR START
//   //   if (subFlow[currentIndex].kind == 3 ) {
//   //     if(skipping == false){
//   //       setState(() {
//   //         previousSubId = subFlow[currentIndex].id;
//   //       });
//   //     }
//   //     setState(() {
//   //       currentIndex = getSubIndexById(subFlow[currentIndex].next![0].destElementId!);
//   //       subFlow[currentIndex].previousId = preId;
//   //     });
//   //     if(checkCondition()==true){
//   //       if(skipping == false){
//   //         setState(() {
//   //           preId = previousSubId;
//   //           subFlow[currentIndex].previousId=preId;
//   //           // skipping = false;
//   //         });
//   //       }
//   //       if(skipping==true){
//   //         setState(() {
//   //           skipping=false;
//   //           // preId = subFlow[currentIndex].id;
//   //         });
//   //       }
//   //     }
//   //     else{
//   //       setState(() {
//   //         skipping = true;
//   //         preId = previousSubId;
//   //       });
//   //       incrementForSubFlow();
//   //     }
//   //     return;
//   //   }
//   //
//   //   ///FOR END
//   //   if (subFlow[currentIndex].kind == 4 ) {
//   //
//   //     if(skipping == false){
//   //       setState(() {
//   //         previousSubId = subFlow[currentIndex].id;
//   //       });
//   //     }
//   //
//   //     if(subFlow[currentIndex].prevSubFlowQuestion==null || subFlow[currentIndex].prevSubFlowQuestion.isEmpty)
//   //     {
//   //       setState(() {
//   //
//   //         isMasterFlowActive = true;
//   //         subFlow[currentIndex].previousId=preId;
//   //
//   //       });
//   //       if(isMasterFlowActive == true){
//   //         setState(() {
//   //           currentIndex = subFlow.length;
//   //         });
//   //       }
//   //       if(checkCondition()==true){
//   //         if(skipping == false){
//   //           setState(() {
//   //             preId = previousSubId;
//   //             subFlow[currentIndex].previousId=preId;
//   //             // skipping = false;
//   //           });
//   //         }
//   //         if(skipping==true){
//   //           setState(() {
//   //             skipping=false;
//   //             // preId = subFlow[currentIndex].id;
//   //           });
//   //         }
//   //       }
//   //       else{
//   //         setState(() {
//   //           skipping = true;
//   //           preId = previousSubId;
//   //         });
//   //         incrementForSubFlow();
//   //       }
//   //     }
//   //     else{
//   //       setState(() {
//   //         currentIndex=getSubIndexById(subFlow[currentIndex].prevSubFlowQuestion);
//   //         subFlow[currentIndex].previousId=preId;
//   //       });
//   //       if(checkCondition()==true){
//   //         if(skipping == false){
//   //           setState(() {
//   //             preId = previousSubId;
//   //             subFlow[currentIndex].previousId=preId;
//   //             // skipping = false;
//   //           });
//   //         }
//   //         if(skipping==true){
//   //           setState(() {
//   //             skipping=false;
//   //             // preId = subFlow[currentIndex].id;
//   //           });
//   //         }
//   //       }
//   //       else{
//   //         setState(() {
//   //           skipping = true;
//   //           preId = previousSubId;
//   //         });
//   //         incrementForSubFlow();
//   //       }
//   //     }
//   //     return;
//   //   }
//   //   ///LOGIC ENDS FOR SUB-FLOW LIST INCREMENT
//   // }
//
//
//   decrementForMainFlow(){
//
//     if(masterFlow[currentMainIndex].kind == 3){
//       if(currentMainIndex != 0){
//         for (int i = 0; i < startEndIndex.length; i++) {
//           print("this is list after ${masterFlow[i].text}");
//           if(currentMainIndex == startEndIndex[0].start){
//             setState(() {
//               masterFlow.removeRange(startEndIndex[i].start, startEndIndex[i].end+1);
//               currentMainIndex = getMainIndexById(masterFlow[currentMainIndex-1].id);
//               answerController.text = masterFlow[currentMainIndex].answer;
//               startEndIndex.clear();
//               print("cleared list ${startEndIndex}");
//               printFlow();
//             });
//           }
//           if (startEndIndex.isNotEmpty && currentMainIndex == startEndIndex[i].start! ) {
//             setState(() {
//               masterFlow.removeRange(startEndIndex[i].start, startEndIndex[i].end+1);
//               currentMainIndex = getMainIndexById(masterFlow[currentMainIndex-1].id);
//               answerController.text = masterFlow[currentMainIndex].answer;
//             });
//           }
//         }
//       } else {
//         setState(() {
//           currentMainIndex = getMainIndexById(masterFlow[currentMainIndex].previousId);
//           answerController.text = masterFlow[currentMainIndex].answer;
//         });
//       }
//       return;
//     }
//
//
//     if(masterFlow[currentMainIndex].kind == 4){
//       setState(() {
//         currentMainIndex=getMainIndexById(masterFlow[currentMainIndex].previousId);
//         answerController.text = masterFlow[currentMainIndex].answer;
//       });
//       return;
//     }
//     if(masterFlow[currentMainIndex].kind == 0){
//       setState(() {
//         currentMainIndex=getMainIndexById(masterFlow[currentMainIndex].previousId);
//         answerController.text = masterFlow[currentMainIndex].answer;
//       });
//       return;
//     }
//     if(masterFlow[currentMainIndex].kind == 1){
//       setState(() {
//         currentMainIndex=getMainIndexById(masterFlow[currentMainIndex].previousId);
//         answerController.text = masterFlow[currentMainIndex].answer;
//       });
//       return;
//     }
//     if(masterFlow[currentMainIndex].kind == 7){
//       setState(() {
//         currentMainIndex=getMainIndexById(masterFlow[currentMainIndex].previousId);
//         answerController.text = masterFlow[currentMainIndex].answer;
//       });
//       return;
//     }
//
//     // print("currentMainIndex before decrementing : $currentMainIndex ${masterFlow[currentMainIndex].previousId} ");
//     // print("length ${subFlow.length}");
//
//     // if(subFlow.isNotEmpty ){
//     //   setState(() {
//     //     masterFlow[currentMainIndex].previousId = subFlow.last.id;
//     //     currentIndex = getSubIndexById(masterFlow[currentMainIndex].previousId);
//     //     isMasterFlowActive = false;
//     //   });
//     // }
//     // else{
//
//     // }
//
//   }
//
//
//   // decrementForSubFlow(){
//   //   ///IF WE REACH THE FIRST SUBFLOW'S FIRST QUESTION WE SHOULD BE MOVING BACK TO MASTER FLOW
//   //
//   //   // if(subFlow.isNotEmpty && subFlow[currentIndex].kind == 3 && isMasterFlowActive == false){
//   //   //   print("hiiiii");
//   //   //   int Id = getMainIndexById(masterFlow[currentMainIndex-2].id);
//   //   //
//   //   //   print("This is id : ${Id} and text ${masterFlow[Id].text}");
//   //   //
//   //   //   subFlow[currentIndex].previousId = masterFlow[Id].id;
//   //   //
//   //   //   print("this is ${subFlow[currentIndex].previousId} and text is ${subFlow[currentIndex].text}");
//   //   //   isMasterFlowActive = true;
//   //   //   if(isMasterFlowActive == true){
//   //   //     currentMainIndex = currentMainIndex-2;
//   //   //   }
//   //   //
//   //   // }
//   //   if(currentIndex==0){
//   //     setState(() {
//   //       isMasterFlowActive=true;
//   //       currentMainIndex = getMainIndexById(subFlow[currentIndex].previousId);
//   //       ///CLEAR SUB FLOW LIST, SO WE CAN MOVE AGAIN ACROSS FLOWCHARTS subFlow.clear()
//   //
//   //       subFlow = [];
//   //       print("subflow : ${subFlow}");
//   //     });
//   //   }
//   //   if(subFlow.isNotEmpty && subFlow[currentIndex].kind == 3){
//   //     print("sub flow length ${subFlow.length}");
//   //     subFlow.removeRange(subFlowPreLength, subFlow.length-1);
//   //     setState(() {
//   //       subFlowPreLength = subFlow.length;
//   //     });
//   //     print("sub flow length ${subFlow.length}");
//   //   }
//   //   else {
//   //     setState(() {
//   //       print("${subFlow[currentIndex].text} _____${subFlow[currentIndex].previousId}");
//   //       currentIndex = getSubIndexById(subFlow[currentIndex].previousId);
//   //       print("${subFlow[currentIndex].text} _____${subFlow[currentIndex].previousId}");
//   //       print("currentIndex sub flow $currentIndex");
//   //     });
//   //   }
//   // }
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
//   // int getSubIndexById(String id) {
//   //   for (int i = 0; i < subFlow.length; i++) {
//   //     if (subFlow[i].id == id) {
//   //       return i;
//   //     }
//   //   }
//   //   return currentIndex-1;
//   // }
//
//
//   addRangeToModel(){
//       print("this ${masterFlow[currentMainIndex].range[0].min}");
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             masterFlow.isNotEmpty
//                 ? Text("TEXT : ${masterFlow[currentMainIndex].text}")
//                 // : Text("Text : ${subFlow[currentIndex].text}")
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
//                 ElevatedButton(onPressed:() =>
//                     decrementForMainFlow(),
//                 // decrementForSubFlow(),
//                     child: const Icon(Icons.arrow_back)),
//
//                 const SizedBox(
//                   height: 10,
//                 ),
//
//                 ElevatedButton(onPressed:() {
//                   closeKeyBoard();
//                   incrementForMainFlow();},
//                 // incrementForSubFlow(),
//                     child: const Icon(Icons.arrow_forward)),
//
//                 const SizedBox(
//                   height: 10,
//                 ),
//
//                 ElevatedButton(onPressed:() {
//                  addRangeToModel();
//                   },
//                     // incrementForSubFlow(),
//                     child: const Icon(Icons.download_for_offline)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   closeKeyBoard(){
//     FocusScopeNode currentFocus = FocusScope.of(context);
//     currentFocus.unfocus();
//   }
//   bool checkCondition() {
//     bool ageMet = false;
//     bool genderMet = false;
//     bool showQues = false;
//     print("in check condition");
//     // print("length ${subFlow[currentIndex].ageGroup.length}");
//
//       for (int i = 0; i < masterFlow[currentMainIndex].ageGroup.length; i++) {
//         print("in check condition1");
//         if ((age >= masterFlow[currentMainIndex].ageGroup[i].start) &&
//             (age <= masterFlow[currentMainIndex].ageGroup[i].end)) {
//           print("in check condition2");
//           setState(() {
//             ageMet = true;
//             print("in check condition3");
//           });
//         }
//       }
//       for (int i = 0; i < masterFlow[currentMainIndex].genderGroup.length; i++) {
//         print("in check condition4");
//         if (masterFlow[currentMainIndex].genderGroup[i] == gender) {
//           print("in check condition5");
//           setState(() {
//             genderMet = true;
//             print("in check condition6");
//           });
//         }
//       }
//
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