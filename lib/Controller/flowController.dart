import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterdemo/Model/questionModelForMaster.dart';
import 'package:flutterdemo/widgets/TextFieldUi.dart';
import 'package:flutterdemo/widgets/is_numeric_ui.dart';
import 'package:flutterdemo/widgets/nothing.dart';
import 'package:flutterdemo/widgets/toastMessage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FlowController extends GetxController {
  /// VALIDATION FOR TEXT FIELD
  RxBool validate = false.obs;

  ///CURRENT QUESTION INDEX
  RxInt currentMainIndex = 0.obs;

  ///CURRENT QUESTIONS ID
  RxString previousMainId = "".obs;

  ///LIST FOR THE START AND END INDEX WHEN THE NEW FLOW ADDED TO THE MASTER FLOW LIST
  List<StartEndIndex> startEndIndex = [];

  ///LIST OF TYPE ELEMENTS TO GET THE MASTER FLOW AND FOR ALL OTHER SUBFLOWS
  RxList<Elements> masterFlow = <Elements>[].obs;

  ///INSTANCE OF FIREBASE
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ///LIST OF ALL FLOW CHARTS
  List<FlowMain> flowsData = [];

  ///TEXT EDITING CONTROLLER FOR ALL THE ANSWERS
  TextEditingController answerController = TextEditingController();

  ///DEFAULT AGE FOR RENDERING QUESTIONS
  RxDouble age = (35.0).obs;

  ///DEFAULT GENDER FOR RENDERING QUESTIONS
  RxString gender = "female".obs;

  ///FLAG FOR THE QUESTIONS WHERE THE QUESTION GET SKIPPED BASED ON AGE AND GENDER
  RxBool skipping = false.obs;

  ///SAVING THE QUESTION ID FOR ASSIGNING IT TO THAT QUESTION WHERE THE SKIP CONDITION GETS FALSE
  RxString preId = "".obs;

  ///CURRENT QUESTIONS ID WHERE THE NEXT QUESTION IS GETTING SKIPPED
  RxString previousSkipId = "".obs;


  ///INIT METHOD FOR PAGE INITIALIZATION
  @override
  void onInit() async {
    getFlows();
    super.onInit();
  }


  ///FOR GETTING ALL FLOWS FROM FIREBASE
  void getFlows() async {
    try {
      QuerySnapshot<Map<String, dynamic>> res =
      await firebaseFirestore.collection('clinicalPathwayFlowCharts').get();
      flowsData = questionsMainFromJson(res.docs);
      debugPrint("this is the length of the flowsdata list ${flowsData.length}");
      String? id;

      for (FlowMain data in flowsData) {
        if (data.priority == 0) {
          id = data.flowchartId;
          // id = data.flowId;
          debugPrint("haha ${jsonEncode(id)}");
        }
      }

      if (id != null) {
        getMasterFlow(id);
      } else {
        if (kDebugMode) {
          debugPrint("No document with priority value 0 found.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("THIS IS ERROR $e");
      }
    }
  }
  ///GETTING THE MASTER FLOW TO THE MASTERFLOW LIST
  void getMasterFlow(String id) async {
    try {
      if (flowsData.isNotEmpty) {
        FlowMain document = flowsData.firstWhere((data) => data.flowchartId == id);
        debugPrint("ha $document");
        masterFlow.value = document.elements ?? [];
        previousMainId.value = masterFlow[currentMainIndex.value].id;
        masterFlow[currentMainIndex.value].previousId = previousMainId.value;
        for(int i = 0 ; i < masterFlow.length;i++){
          debugPrint("this is master flow $i : ${jsonEncode(masterFlow[i].text)}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  ///ADDING THE SUBFLOW TO THE MASTERFLOW LIST JUST AFTER THE CURRENT INDEX WHEN THE CONNECTOR COMES
  void getSubFlow(String id) {
    try {
      FlowMain? document = flowsData.firstWhere((data) =>
      data.flowchartId == id);
      masterFlow.insertAll(currentMainIndex.value + 1, document.elements!);
      for(int i = 0 ; i < masterFlow.length;i++){
        debugPrint("this is master flow $i : ${jsonEncode(masterFlow[i].text)}");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }


  ///ADDING THE FIRST AND THE LAST SUB FLOW INDEX TO THE MODEL LIST TO USE IT IN FUTURE
  Future<void> addIndex({required int start, required int end,required bool skipped}) async {
    try {
      StartEndIndex index = StartEndIndex(
          start: start, end: end, skipped: skipped);
      startEndIndex.add(index);
      debugPrint(
          "startEndIndex after adding range ${jsonEncode(startEndIndex)}");
    } catch (error) {
      debugPrint("FAILED TO LOG THE ERROR TO DB");
    }
  }


  ///GETTING THE AGE INPUT FROM USER
  void enterAge() {
    if (masterFlow[currentMainIndex.value].text == "Select Date of Birth") {
      age.value = double.tryParse(masterFlow[currentMainIndex.value].answer) ?? 18.0;
    }
  }

  ///GETTING THE GENDER INPUT FR OM USER
  void enterGender() {
    if (masterFlow[currentMainIndex.value].text == "Select Gender") {
      gender.value = masterFlow[currentMainIndex.value].answer ?? "female";
    }
  }

  ///CHECKING IF THE ANSWER AVAILABLE IN FIREBASE OR NOT IF AVAILABLE THAN PREFETCH IT TO THE TEXT FIELD
  checkAnswerAvailable() {
    try {
      if (masterFlow[currentMainIndex.value].answer != "" ||
          masterFlow[currentMainIndex.value].answer != null) {
        answerController.text = masterFlow[currentMainIndex.value].answer;

      }
    } catch (e) {
      debugPrint("got an error $e");
    }
  }

  ///CHECK ANC PNC QUESTIONS
  checkForAncPnc(){
    if(masterFlow[currentMainIndex.value].kind == 4){
      if(checkCondition(currentMainIndex.value) == false && masterFlow[currentMainIndex.value].isPregnancy == true){
        skipping.value = true;
        currentMainIndex.value = getMainIndexById(masterFlow[currentMainIndex.value].next![1].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        checkForAncPnc();
        update();
        incrementForMainFlow();
      }else{
        if(checkCondition(currentMainIndex.value) == true){
          skipping.value = false;
          update();
        }
      }
      if(checkCondition(currentMainIndex.value) == false && masterFlow[currentMainIndex.value].isPregnancy == false){
        skipping.value = true;
        currentMainIndex.value = getMainIndexById(masterFlow[currentMainIndex.value].next![1].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        checkForAncPnc();
        update();
        incrementForMainFlow();
      }else{
        skipping.value = false;
        update();
      }
    }
    return;
  }


  ///CHECK AGE AND GENDER CONDITIONS
  bool checkCondition( var index) {
    bool ageMet = false;
    bool genderMet = false;
    bool showQues = false;

    for (int i = 0;
    i < masterFlow[index].ageGroup.length;
    i++) {
      if ((age.value >= masterFlow[index].ageGroup[i].start) &&
          (age.value <= masterFlow[index].ageGroup[i].end)) {
        ageMet = true;
      }
    }

    for (int i = 0;
    i < masterFlow[index].genderGroup.length;
    i++) {
      if (masterFlow[index].genderGroup[i] == gender.value) {
        genderMet = true;
      }
    }

    if (ageMet == true && genderMet == true) {
      showQues = true;
    }
    return showQues;
  }


  ///GETTING THE INDEX USING THE ID
  int getMainIndexById(String id) {
    int index = masterFlow.indexWhere((element) => element.id == id);
    return index >= 0 ? index : currentMainIndex.value - 1;
  }


  /// INCREMENT LOGIC FOR QUESTIONS
  Future<void> incrementForMainFlow() async {

    // vitalValidation();

    previousMainId.value = masterFlow[currentMainIndex.value].id;
    masterFlow[currentMainIndex.value].answer = answerController.text;
    update();

    switch(masterFlow[currentMainIndex.value].kind){
    ///FOR NORMAL QUESTIONS
      case 0 :{
        enterAge();
        enterGender();

        if (skipping.value == false) {
          previousSkipId.value = masterFlow[currentMainIndex.value].id;
          update();
        }
        currentMainIndex.value = getMainIndexById(
            masterFlow[currentMainIndex.value].next![0].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        answerController.clear();
        await checkAnswerAvailable();
        update();

        if (checkCondition(currentMainIndex.value) == true) {
          if (skipping.value == false) {
            preId.value = previousSkipId.value;
            masterFlow[currentMainIndex.value].previousId = preId.value;
            update();
          }
          if (skipping.value == true) {
            skipping.value = false;
            update();
          }
        } else {
          skipping.value = true;
          preId.value = previousSkipId.value;
          update();
          incrementForMainFlow();
        }
      }
      break;


    ///FOR CONDITIONAL QUESTIONS
      case 4:{
        if (skipping.value == false) {
          previousSkipId.value = masterFlow[currentMainIndex.value].id;
          debugPrint("this is current question id ${previousSkipId.value} \n"
              " and this is current question ${masterFlow[currentMainIndex.value].text} \n "
              "and this is previous id ${masterFlow[currentMainIndex.value].previousId}");
          update();
        }



        /// IF ANSWER IS YES
        if (answerController.value.text == "1") {
          currentMainIndex.value = getMainIndexById(masterFlow[currentMainIndex.value].next![0].destElementId!);
          masterFlow[currentMainIndex.value].previousId = preId.value;
          answerController.clear();
          await checkAnswerAvailable();
          update();


          if (checkCondition(currentMainIndex.value) == true) {
            if (skipping.value == false) {
              preId.value = previousSkipId.value;
              masterFlow[currentMainIndex.value].previousId = preId.value;
              update();
            }
            if (skipping.value == true) {
              skipping.value = false;
              update();
            }
          } else {
            skipping.value = true;
            preId.value = previousSkipId.value;
            update();
            incrementForMainFlow();
            checkForAncPnc();
          }
          return;
        }


        /// IF ANSWER IS NO
        if (answerController.value.text == "0") {
          currentMainIndex.value = getMainIndexById(
              masterFlow[currentMainIndex.value].next![1].destElementId!);
          masterFlow[currentMainIndex.value].previousId = preId.value;
          answerController.clear();
          await checkAnswerAvailable();
          update();

          if (checkCondition(currentMainIndex.value) == true) {
            if (skipping.value == false) {
              preId.value = previousSkipId.value;
              masterFlow[currentMainIndex.value].previousId = preId.value;
              update();
            }
            if (skipping.value == true) {
              skipping.value = false;
              update();
            }
          } else {
            skipping.value = true;
            preId.value = previousSkipId.value;
            update();
            incrementForMainFlow();
            checkForAncPnc();
          }

          return;
        }

        ///IF THERE IS MORE THAN 2 PATHS FR OM A DIAMOND
        if (answerController.value.text == "2") {
          currentMainIndex.value = getMainIndexById(
              masterFlow[currentMainIndex.value].next![2].destElementId!);
          masterFlow[currentMainIndex.value].previousId = preId.value;
          answerController.clear();
          await checkAnswerAvailable();
          update();

          if(masterFlow[currentMainIndex.value].isPregnancy == true && checkCondition(currentMainIndex.value) == false){
            print("i am ravi3");
            skipping.value = true;
            preId.value = previousSkipId.value;
            currentMainIndex.value = getMainIndexById(masterFlow[currentMainIndex.value].next![0].destElementId!);
            masterFlow[currentMainIndex.value].previousId = preId.value;
            update();
            incrementForMainFlow();
            return;
          }

          if (checkCondition(currentMainIndex.value) == true) {
            if (skipping.value == false) {
              preId.value = previousSkipId.value;
              masterFlow[currentMainIndex.value].previousId = preId.value;
              update();
            }
            if (skipping.value == true) {
              skipping.value = false;
              update();
            }
          } else {
            skipping.value = true;
            preId.value = previousSkipId.value;
            update();
            incrementForMainFlow();
            checkForAncPnc();
          }
          return;
        }
      }
      break;


    ///FOR START ELEMENT
      case 2:{
        if (skipping.value == false) {
          previousSkipId.value = masterFlow[currentMainIndex.value].id;
          update();
        }
        // vitalValidation();
        currentMainIndex.value = getMainIndexById(
            masterFlow[currentMainIndex.value].next![0].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        answerController.clear();
        await checkAnswerAvailable();
        update();
        if (checkCondition(currentMainIndex.value) == true) {
          if (skipping.value == false) {
            preId.value = previousSkipId.value;
            masterFlow[currentMainIndex.value].previousId = preId.value;
            update();
          }
          if (skipping.value == true) {
            skipping.value = false;
            update();
          }
        } else {
          skipping.value = true;
          preId.value = previousSkipId.value;
          update();
          incrementForMainFlow();
        }
      }
      break;


    ///FOR END ELEMENT
      case 3:{
        if(currentMainIndex.value != masterFlow.length - 1){
          if (skipping.value == false) {
            previousSkipId.value = masterFlow[currentMainIndex.value].id;
            update();
          }

          for (int v = 0; v < masterFlow.length; v++) {
            if (masterFlow[v].endId == masterFlow[currentMainIndex.value].id) {
              currentMainIndex.value =
                  getMainIndexById(masterFlow[v].next![0].destElementId!);
              answerController.clear();
              await checkAnswerAvailable();
              update();
            }
          }
          masterFlow[currentMainIndex.value].previousId = preId.value;
          update();
          if (checkCondition(currentMainIndex.value) == true) {
            if (skipping.value == false) {
              preId.value = previousSkipId.value;
              masterFlow[currentMainIndex.value].previousId = preId.value;
              update();
            }
            if (skipping.value == true) {
              skipping.value = false;
              update();
            }
          } else {
            skipping.value = true;
            preId.value = previousSkipId.value;
            update();
            incrementForMainFlow();
          }
        }
      }
      break;


    /// FOR CONNECTOR
      case 1:{
        getSubFlow(masterFlow[currentMainIndex.value].navigationId);
        if (skipping.value == false) {
          previousSkipId.value = masterFlow[currentMainIndex.value].id;
          update();
        }
        addIndex(
          start: getMainIndexById(masterFlow[currentMainIndex.value].startId),
          end: getMainIndexById(masterFlow[currentMainIndex.value].endId),
          skipped: skipping.value,
        );
        // removeSkippedFlow();
        currentMainIndex.value =
            getMainIndexById(masterFlow[currentMainIndex.value].startId);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        answerController.clear();
        await checkAnswerAvailable();
        update();
        if (checkCondition(currentMainIndex.value) == true) {
          if (skipping.value == false) {
            preId.value = previousSkipId.value;
            masterFlow[currentMainIndex.value].previousId = preId.value;
            update();
          }
          if (skipping.value == true) {
            skipping.value = false;
            update();
          }
        } else {
          skipping.value = true;
          preId.value = previousSkipId.value;
          update();
          incrementForMainFlow();
        }
      }
      break;


    ///FOR OPTIONS
      case 7 :
      case 8 :{
        enterAge();
        enterGender();

        if (skipping.value == false) {
          previousSkipId.value = masterFlow[currentMainIndex.value].id;
          update();
        }
        currentMainIndex.value = getMainIndexById(
            masterFlow[currentMainIndex.value].next![0].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        answerController.clear();
        await checkAnswerAvailable();
        update();

        if (checkCondition(currentMainIndex.value) == true) {
          if (skipping.value == false) {
            preId.value = previousSkipId.value;
            masterFlow[currentMainIndex.value].previousId = preId.value;
            update();
          }
          if (skipping.value == true) {
            skipping.value = false;
            update();
          }
        } else {
          skipping.value = true;
          preId.value = previousSkipId.value;
          update();
          incrementForMainFlow();
        }
      }
      break;
    }
  }

  /// DECREMENT LOGIC FOR QUESTIONS
  Future<void> decrementForMainFlow() async {
    switch (masterFlow[currentMainIndex.value].kind) {
      case 2:
        {
          if (currentMainIndex.value != 0) {
            for (int i = 0; i < startEndIndex.length; i++) {
              if (currentMainIndex.value == startEndIndex[0].start) {
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                debugPrint("index before $currentMainIndex");
                masterFlow.removeRange(
                    startEndIndex[i].start, startEndIndex[i].end + 1);
                currentMainIndex.value =
                    getMainIndexById(masterFlow[currentMainIndex.value-1].id);
                debugPrint( "dsasassaas ${getMainIndexById(masterFlow[currentMainIndex.value].previousId)}");
                debugPrint("index after $currentMainIndex");
                answerController.text = masterFlow[currentMainIndex.value].answer;
                startEndIndex.clear();
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                debugPrint("cleared list ${jsonEncode(startEndIndex)}");
                // printFlow();
              }
              if (startEndIndex.isNotEmpty && currentMainIndex.value == startEndIndex[i].start!) {
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                masterFlow.removeRange(startEndIndex[i].start, startEndIndex[i].end + 1);
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                print("masterflow list $masterFlow");
                debugPrint("index before $currentMainIndex");
                currentMainIndex.value = getMainIndexById(masterFlow[currentMainIndex.value - 1].id);
                debugPrint("index after $currentMainIndex");
                answerController.text =
                    masterFlow[currentMainIndex.value].answer;
              }
            }
          } else {
            currentMainIndex.value =
                getMainIndexById(masterFlow[currentMainIndex.value].previousId);
            answerController.text = masterFlow[currentMainIndex.value].answer;
          }
        }
        break;

      case 0:
      case 4:
      case 3:
      case 1:
      case 8:
      case 7:
        {
          currentMainIndex.value =
              getMainIndexById(masterFlow[currentMainIndex.value].previousId);
          answerController.text = masterFlow[currentMainIndex.value].answer;
          ///IF THE SUB FLOW WAS SKIPPED THEN REMOVE THE SUB FLOW FROM THE MASTER FLOW LIST
          // await removeSkippedFlow();
        }
        break;
    }
  }

  ///CHECK IF THE QUESTION IS MANDATORY THAN DON'T SKIP IT
  ///THIS FUNCTION WILL BE USED FOR INCREMENTING THE QUESTIONS
  checkMandatory() {
    /// FOR SYST0LIC AND DIASTOLIC VALIDATION
    if(masterFlow[currentMainIndex.value].selectedGroup == "Vitals") {
      if (masterFlow[currentMainIndex.value].range[0].min != "" &&
          masterFlow[currentMainIndex.value].range[0].max != "" &&
          masterFlow[currentMainIndex.value].range[0].pattern != "") {
        if(answerController.text.split('/').length != 2) {
          showToast("Please enter BP in xxx/xxx Format", ToastGravity.CENTER);
          return;
        }
        else if((double.tryParse(answerController.text.split('/')[0])! < double.tryParse(masterFlow[currentMainIndex.value].range[0].min)!) &&
            (double.tryParse(answerController.text.split('/')[1])! > double.tryParse(masterFlow[currentMainIndex.value].range[0].max)!)) {
          showToast("Invalid values for ${masterFlow[currentMainIndex.value].text}", ToastGravity.CENTER);
          return;
        }
        else if (answerController.text.split('/')[0] == "") {
          showToast("Invalid Systolic value", ToastGravity.CENTER);
          return;
        }
        else if (answerController.text.split('/')[1] == "") {
          showToast("Invalid Diastolic value", ToastGravity.CENTER);
          return;
        }
        else if (double.tryParse(answerController.text.split('/')[0])! <
            double.tryParse(masterFlow[currentMainIndex.value].range[0].min)!) {
          showToast(
              "Invalid Systolic value (out of min range)", ToastGravity.CENTER);
          return;
        }
        else if (double.tryParse(answerController.text.split('/')[1])! >
            double.tryParse(masterFlow[currentMainIndex.value].range[0].max)!) {
          showToast("Invalid Diastolic value (out of max range)",
              ToastGravity.CENTER);
          return;
        }else{
          incrementForMainFlow();
          return;
        }
      }else{
        incrementForMainFlow();
        return;
      }
    }

    if(masterFlow[currentMainIndex.value].selectedGroup == "Vitals"){
      if(masterFlow[currentMainIndex.value].range[0].min != "" &&
          masterFlow[currentMainIndex.value].range[0].max != "" ){
        if(double.tryParse(answerController.text)! < double.tryParse(masterFlow[currentMainIndex.value].range[0].min)!  ||
            double.tryParse(answerController.text)! > double.tryParse(masterFlow[currentMainIndex.value].range[0].max)!){
          showToast(
              "invalid value for ${masterFlow[currentMainIndex.value].text}",
              ToastGravity.CENTER);
          return;
        }else{
          incrementForMainFlow();
          return;
        }
      }else{
        incrementForMainFlow();
        return;
      }
    }

    if (masterFlow[currentMainIndex.value].isMandatory == "true" && masterFlow[currentMainIndex.value].selectedGroup != "Vitals") {
      ///VALIDATIONS
      if (answerController.text.isEmpty) {
        showToast(
            "Please enter the ${masterFlow[currentMainIndex.value].text}",
            ToastGravity.CENTER);
        return;
      }
      if (answerController.text.isNotEmpty) {
        incrementForMainFlow();
        return;
      }
    }
    if (masterFlow[currentMainIndex.value].isMandatory == "false" && masterFlow[currentMainIndex.value].selectedGroup != "Vitals") {
      ///VALIDATIONS
      if (answerController.text.isEmpty || answerController.text.isNotEmpty) {
        incrementForMainFlow();
        return;
      }
    }
  }

  ///UPDATE UI ACCORDING TO THE SELECTED MODE OF THE QUESTION
 Widget updateUi(){
    switch(masterFlow[currentMainIndex.value].selectedMode){
      case "textEditor":{
        return const TextEditorUiPage();
      }
      case "isNumeric":{
        return const IsNumericUiPage();
      }
      case "isOptions":{
        return const NothingUiPage();
      }
      case "isDateField":{
        return const NothingUiPage();
      }
      case "isDateTimeField":{
        return const NothingUiPage();
      }
      case "duration":{
        return const NothingUiPage();
      }
      case "isMultiOptions":{
        return const NothingUiPage();
      }
      case "":{
        return const NothingUiPage();
      }
    }
    return Container(
      color: Colors.teal,
    );
  }
}
