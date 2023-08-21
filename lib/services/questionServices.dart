import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/Model/questionModelForMaster.dart';
import 'package:get/get.dart';


final FlowController flowController = Get.find<FlowController>();

class QuestionsService {
  ///Get Firestore instance for the retrieval of questions from firestore database
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ///Get Firebase Storage instance for the audio,video and image storage of the patient
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;


  void getFlows() async {
    try {
      QuerySnapshot<Map<String, dynamic>> res =
      await firebaseFirestore.collection('clinicalPathwayFlowCharts').get();
      flowController.flowsData= questionsMainFromJson(res.docs);
      debugPrint(
          "this is the length of the flowsdata list ${flowController.flowsData.length}");
      String? id;

      for (FlowMain data in flowController.flowsData) {
        if (data.priority == 0) {
          id = data.flowchartId;
          print("this is flow chart name ${data.flowchartName}");
          // id = data.flowId;
          debugPrint("haha ${jsonEncode(id)}");
        }
      }
      if (id != null) {
        getMasterFlow(id);
      } else {
          debugPrint("No document with priority value 0 found.");

      }
    } catch (e) {

        debugPrint("THIS IS ERROR $e");

    }
  }


  ///GETTING THE MASTER FLOW TO THE MASTERFLOW LIST
  void getMasterFlow(String id) async {
    try {
      if (flowController.flowsData.isNotEmpty) {
        FlowMain document = flowController.flowsData.firstWhere((data) =>
        data.flowchartId == id);
        debugPrint("ha $document");
        flowController.masterFlow.value = document.elements ?? [];
        flowController.previousMainId.value = flowController.masterFlow[flowController.currentMainIndex.value].id;
        flowController.masterFlow[flowController.currentMainIndex.value].previousId = flowController.previousMainId.value;
        for (int i = 0; i < flowController.masterFlow.length; i++) {
          debugPrint(
              "this is master length $i : ${jsonEncode(flowController.masterFlow.length)}");
          debugPrint(
              "this is master flow $i : ${jsonEncode(flowController.masterFlow[i].text)}");
        }
      }
    } catch (e) {
        print(e);
    }
  }
}