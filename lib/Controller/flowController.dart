import 'dart:convert';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterdemo/Model/questionModelForMaster.dart';
import 'package:flutterdemo/constants/appColors.dart';
import 'package:flutterdemo/constants/screenSize.dart';
import 'package:flutterdemo/services/questionServices.dart';
import 'package:flutterdemo/widgets/bottomSheet.dart';
import 'package:flutterdemo/widgets/titleTextField.dart';
import 'package:flutterdemo/widgets/toastMessage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FlowController extends GetxController {

  RxInt i = 0.obs;

  RxString formattedDate = "".obs;



  RxMap<dynamic,dynamic> checkboxes = {}.obs;
  RxMap<dynamic, dynamic> dates = {}.obs;
  RxInt currentIndex = 0.obs;


  RxBool isSelected = false.obs;


  List<String> options = [];

  List<String> immunizationSegment = [];

  RxInt optionsChoiceIndex = (-1).obs;
  RxString optionsChoiceTag = "".obs;

  List<String> multiOptionsStringList = [];

  RxString multiOptionsString = "".obs;

  RxString selectedDateRangeFormat = "days".obs;

  ///PATIENT IS NEW OR NOT
  RxBool isNewPatient = true.obs;

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


  ///INITIALIZATION OF QUESTION SERVICES
  QuestionsService quewstionServices = QuestionsService();

  ///INSTANCE OF FIREBASE
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ///LIST OF ALL FLOW CHARTS
  List<FlowMain> flowsData = [];

  ///TEXT EDITING CONTROLLER FOR ALL THE ANSWERS
  TextEditingController answerController = TextEditingController();

  ///TEXT EDITING CONTROLLER FOR ALL THE AGE IN YEARS
  TextEditingController answerYearsController = TextEditingController();

  ///TEXT EDITING CONTROLLER FOR ALL THE AGE IN MONTHS
  TextEditingController answerMonthsController = TextEditingController();

  ///TEXT EDITING CONTROLLER FOR ALL THE AGE IN DAYS
  TextEditingController answerDaysController = TextEditingController();

  ///TEXT EDITING CONTROLLER FOR ALL THE AGE IN DAYS
  TextEditingController givenDateForImmunizationController = TextEditingController();

  DateTime selectedDateDob = DateTime.now();

  ///Immunization
  DateTime selectedDate = DateTime.now();

  ///DEFAULT AGE FOR RENDERING QUESTIONS
  RxDouble age = (17.0).obs;

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
    quewstionServices.getFlows();
    super.onInit();
  }


  ///FOR GETTING ALL FLOWS FROM FIREBASE
  // void getFlows() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> res =
  //     await firebaseFirestore.collection('clinicalPathwayFlowCharts').get();
  //     flowsData = questionsMainFromJson(res.docs);
  //     debugPrint(
  //         "this is the length of the flowsdata list ${flowsData.length}");
  //     String? id;
  //
  //     for (FlowMain data in flowsData) {
  //       if (data.priority == 0) {
  //         id = data.flowchartId;
  //         print("this is flow chart name ${data.flowchartName}");
  //         // id = data.flowId;
  //         debugPrint("haha ${jsonEncode(id)}");
  //       }
  //     }
  //     if (id != null) {
  //       getMasterFlow(id);
  //     } else {
  //       if (kDebugMode) {
  //         debugPrint("No document with priority value 0 found.");
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       debugPrint("THIS IS ERROR $e");
  //     }
  //   }
  // }


  ///GETTING THE MASTER FLOW TO THE MASTERFLOW LIST
  // void getMasterFlow(String id) async {
  //   try {
  //     if (flowsData.isNotEmpty) {
  //       FlowMain document = flowsData.firstWhere((data) =>
  //       data.flowchartId == id);
  //       debugPrint("ha $document");
  //       masterFlow.value = document.elements ?? [];
  //       previousMainId.value = masterFlow[currentMainIndex.value].id;
  //       masterFlow[currentMainIndex.value].previousId = previousMainId.value;
  //       for (int i = 0; i < masterFlow.length; i++) {
  //         debugPrint(
  //             "this is master length $i : ${jsonEncode(masterFlow.length)}");
  //         debugPrint(
  //             "this is master flow $i : ${jsonEncode(masterFlow[i].text)}");
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }


  ///ADDING THE SUBFLOW TO THE MASTERFLOW LIST JUST AFTER THE CURRENT INDEX WHEN THE CONNECTOR COMES
  void getSubFlow(String id) {
    try {
      FlowMain? document = flowsData.firstWhere((data) =>
      data.flowchartId == id);
      masterFlow.insertAll(currentMainIndex.value + 1, document.elements!);
      for (int i = 0; i < masterFlow.length; i++) {
        debugPrint(
            "this is master flow $i : ${jsonEncode(masterFlow[i].text)}");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }


  ///ADDING THE FIRST AND THE LAST SUB FLOW INDEX TO THE MODEL LIST TO USE IT IN FUTURE
  Future<void> addIndex(
      {required int start, required int end, required bool skipped}) async {
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
      age.value = 0.0;
      print("age value before ${age.value}");
      age.value =
          double.tryParse(masterFlow[currentMainIndex.value].answer) ?? 18.0;
      print("this is the agr in answer ${masterFlow[currentMainIndex.value]
          .answer}");
      update();
      print("age value after ${age.value}");
    }
  }

  ///GETTING THE GENDER INPUT FR OM USER
  void enterGender() {
    if (masterFlow[currentMainIndex.value].text == "Select Gender") {
      gender.value = "";
      update();
      print("gender value before ${gender.value}");
      for (int i = 0; i < options.length; i++) {
        if (i == optionsChoiceIndex.value) {
          answerController.text = options[i].toLowerCase();
          gender.value = answerController.text;
          masterFlow[currentMainIndex.value].answer = gender.value;
          update();
        }
      }
      print("gender value after ${gender.value}");
    }
  }

  ///CHECKING IF THE ANSWER AVAILABLE IN FIREBASE OR NOT IF AVAILABLE THAN PREFETCH IT TO THE TEXT FIELD
  checkAnswerAvailable() {
    try {
      if (masterFlow[currentMainIndex.value].answer != "" ||
          masterFlow[currentMainIndex.value].answer != null) {
        answerController.text = masterFlow[currentMainIndex.value].answer;
      }
      if (masterFlow[currentMainIndex.value].selectedMode == "isOptions") {
        if (masterFlow[currentMainIndex.value].answer != null &&
            masterFlow[currentMainIndex.value].answer != "") {
          List optionsList = masterFlow[currentMainIndex.value].options!.split(
              "#");
          for (int index = 0; index < optionsList.length; index++) {
            if (optionsList[index] ==
                masterFlow[currentMainIndex.value].answer) {
              print("this is answer ${masterFlow[currentMainIndex.value]
                  .answer}");
              print("this is options Tag value ${optionsChoiceTag.value}");
              optionsChoiceTag.value =
                  optionsList[index].toString().toLowerCase();
              print("this is options Tag value ${optionsChoiceTag.value}");
              optionsChoiceIndex.value = index;
            }
          }
        }
      }
      if (masterFlow[currentMainIndex.value].kind == 8 &&
          masterFlow[currentMainIndex.value].selectedMode == "isMultiOptions") {
        if (masterFlow[currentMainIndex.value].answer != null &&
            masterFlow[currentMainIndex.value].answer != "") {
          multiOptionsString.value = masterFlow[currentMainIndex.value].answer!;
          multiOptionsStringList =
              masterFlow[currentMainIndex.value].answer!.split("#");
        }
      }
      if(masterFlow[currentMainIndex.value].selectedGroup == "Immunization" &&
          masterFlow[currentMainIndex.value].answer != ""){
        isSelected.value = true;
      }
      if(masterFlow[currentMainIndex.value].selectedGroup == "Immunization" &&
          masterFlow[currentMainIndex.value].answer == ""){
        isSelected.value = false;
      }
    } catch (e) {
      debugPrint("got an error $e");
    }
  }


  ///CHECK ANC PNC QUESTIONS
  checkForAncPnc() {
    if (masterFlow[currentMainIndex.value].kind == 4) {
      if (checkCondition(currentMainIndex.value) == false &&
          masterFlow[currentMainIndex.value].isPregnancy == true) {
        skipping.value = true;
        currentMainIndex.value = getMainIndexById(
            masterFlow[currentMainIndex.value].next![1].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        checkForAncPnc();
        update();
        incrementForMainFlow();
      } else {
        if (checkCondition(currentMainIndex.value) == true) {
          skipping.value = false;
          update();
        }
      }
      if (checkCondition(currentMainIndex.value) == false &&
          masterFlow[currentMainIndex.value].isPregnancy == false) {
        skipping.value = true;
        currentMainIndex.value = getMainIndexById(
            masterFlow[currentMainIndex.value].next![1].destElementId!);
        masterFlow[currentMainIndex.value].previousId = preId.value;
        checkForAncPnc();
        update();
        incrementForMainFlow();
      } else {
        skipping.value = false;
        update();
      }
    }
    return;
  }


  ///CHECK AGE AND GENDER CONDITIONS
  bool checkCondition(var index) {
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


  ///SAVE CONDITIONAL QUESTION SELECTED CHOICE TO ANSWER CONTROLLER
  saveOptionForConditionalQuestions() {
    for (int i = 0; i < options.length; i++) {
      if (optionsChoiceIndex.value == i) {
        answerController.text = options[i].toLowerCase();
        masterFlow[currentMainIndex.value].answer = answerController.text;
        update();
      }
    }
  }

  ///RESET VALUES WHEN REQUIRED
  resetValues() {
    optionsChoiceIndex.value = -1;
    multiOptionsStringList = [];
  }

  /// INCREMENT LOGIC FOR QUESTIONS
  Future<void> incrementForMainFlow() async {
    // vitalValidation();
    previousMainId.value = masterFlow[currentMainIndex.value].id;
    masterFlow[currentMainIndex.value].answer = answerController.text;
    print(" this is the ans 1 : ${masterFlow[currentMainIndex.value].answer}");
    isSelected.value = false;
    print(" this is the ans 2 : ${masterFlow[currentMainIndex.value].answer}");

    update();

    switch (masterFlow[currentMainIndex.value].kind) {
    ///FOR NORMAL QUESTIONS
      case 0 :
        {
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
          resetValues();
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
      case 4:
        {
          if (skipping.value == false) {
            previousSkipId.value = masterFlow[currentMainIndex.value].id;
            debugPrint("this is current question id ${previousSkipId.value} \n"
                " and this is current question ${masterFlow[currentMainIndex
                .value].text} \n "
                "and this is previous id ${masterFlow[currentMainIndex.value]
                .previousId}");
            update();
          }

          /// IF ANSWER IS YES
          if (optionsChoiceIndex.value == 0) {
            saveOptionForConditionalQuestions();
            currentMainIndex.value = getMainIndexById(
                masterFlow[currentMainIndex.value].next![0].destElementId!);
            masterFlow[currentMainIndex.value].previousId = preId.value;
            answerController.clear();
            resetValues();
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
          if (optionsChoiceIndex.value == 1) {
            saveOptionForConditionalQuestions();
            currentMainIndex.value = getMainIndexById(
                masterFlow[currentMainIndex.value].next![1].destElementId!);
            masterFlow[currentMainIndex.value].previousId = preId.value;
            answerController.clear();
            resetValues();
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
          if (optionsChoiceIndex.value == 2) {
            currentMainIndex.value = getMainIndexById(
                masterFlow[currentMainIndex.value].next![2].destElementId!);
            masterFlow[currentMainIndex.value].previousId = preId.value;
            answerController.clear();
            resetValues();
            await checkAnswerAvailable();
            update();

            if (masterFlow[currentMainIndex.value].isPregnancy == true &&
                checkCondition(currentMainIndex.value) == false) {
              print("i am ravi3");
              skipping.value = true;
              preId.value = previousSkipId.value;
              currentMainIndex.value = getMainIndexById(
                  masterFlow[currentMainIndex.value].next![0].destElementId!);
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
      case 2:
        {
          if (skipping.value == false) {
            previousSkipId.value = masterFlow[currentMainIndex.value].id;
            update();
          }
          // vitalValidation();
          currentMainIndex.value = getMainIndexById(
              masterFlow[currentMainIndex.value].next![0].destElementId!);
          masterFlow[currentMainIndex.value].previousId = preId.value;
          answerController.clear();
          resetValues();
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
      case 3:
        {
          if (currentMainIndex.value != masterFlow.length - 1) {
            if (skipping.value == false) {
              previousSkipId.value = masterFlow[currentMainIndex.value].id;
              update();
            }

            for (int v = 0; v < masterFlow.length; v++) {
              if (masterFlow[v].endId ==
                  masterFlow[currentMainIndex.value].id) {
                currentMainIndex.value =
                    getMainIndexById(masterFlow[v].next![0].destElementId!);
                answerController.clear();
                resetValues();
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
      case 1:
        {
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
          resetValues();
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
      case 8 :
        {
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
          resetValues();
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
                    getMainIndexById(masterFlow[currentMainIndex.value - 1].id);
                debugPrint("dsasassaas ${getMainIndexById(
                    masterFlow[currentMainIndex.value].previousId)}");
                debugPrint("index after $currentMainIndex");
                answerController.text =
                    masterFlow[currentMainIndex.value].answer;
                checkAnswerAvailable();
                startEndIndex.clear();
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                debugPrint("cleared list ${jsonEncode(startEndIndex)}");
                // printFlow();
              }
              if (startEndIndex.isNotEmpty &&
                  currentMainIndex.value == startEndIndex[i].start!) {
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                masterFlow.removeRange(
                    startEndIndex[i].start, startEndIndex[i].end + 1);
                debugPrint("start end index ${jsonEncode(startEndIndex)}");
                print("masterflow list $masterFlow");
                debugPrint("index before $currentMainIndex");
                currentMainIndex.value =
                    getMainIndexById(masterFlow[currentMainIndex.value - 1].id);
                checkAnswerAvailable();
                debugPrint("index after $currentMainIndex");
                answerController.text =
                    masterFlow[currentMainIndex.value].answer;
              }
            }
          } else {
            currentMainIndex.value =
                getMainIndexById(masterFlow[currentMainIndex.value].previousId);
            answerController.text = masterFlow[currentMainIndex.value].answer;
            checkAnswerAvailable();
            update();
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
          checkAnswerAvailable();
          update();

          ///IF THE SUB FLOW WAS SKIPPED THEN REMOVE THE SUB FLOW FROM THE MASTER FLOW LIST
          // await removeSkippedFlow();
        }
        break;
    }
  }


  ///CHECK IF THE QUESTION IS MANDATORY THAN DON'T SKIP IT
  ///THIS FUNCTION WILL BE USED FOR INCREMENTING THE QUESTIONS
  checkMandatory() {

    if (masterFlow[currentMainIndex.value].text == "Select Date of Birth") {
      answerController.text = answerYearsController.text;
    }
    if (masterFlow[currentMainIndex.value].selectedMode == "isOptions" &&
        masterFlow[currentMainIndex.value].kind == 8) {
      if (masterFlow[currentMainIndex.value].text != "Select Gender") {
        saveValueToAnswerController();
      }
      if (masterFlow[currentMainIndex.value].text == "Select Gender") {
        for (int i = 0; i < options.length; i++) {
          answerController.text = options[i];
          gender.value = answerController.text;
        }
      }
    }

    if (masterFlow[currentMainIndex.value].selectedMode == "isMultiOptions" &&
        masterFlow[currentMainIndex.value].kind == 8) {
      updateListToStringForMultiOptions(
          selectedOptions: multiOptionsStringList);
      answerController.text = multiOptionsString.value;
      update();
      print("this is the list : ${answerController.text}");
    }

    /// FOR SYST0LIC AND DIASTOLIC VALIDATION
    if (masterFlow[currentMainIndex.value].selectedGroup == "Vitals" &&
        masterFlow[currentMainIndex.value].range[0].pattern != "") {
      if (masterFlow[currentMainIndex.value].range[0].min != "" &&
          masterFlow[currentMainIndex.value].range[0].max != ""
          ) {
        if (answerController.text
            .split('/')
            .length != 2) {
          showToast("Please enter BP in xxx/xxx Format", ToastGravity.CENTER);
          return;
        }
        else if ((double.tryParse(answerController.text.split('/')[0])! <
            double.tryParse(masterFlow[currentMainIndex.value].range[0].min)!) &&
            (double.tryParse(answerController.text.split('/')[1])! >
                double.tryParse(
                    masterFlow[currentMainIndex.value].range[0].max)!)) {
          showToast(
              "Invalid values for ${masterFlow[currentMainIndex.value].text}",
              ToastGravity.CENTER);
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
        } else {
          incrementForMainFlow();
          return;
        }
      } else {
        incrementForMainFlow();
        return;
      }
    }

    if(masterFlow[currentMainIndex.value].selectedGroup == "Vitals" &&
        masterFlow[currentMainIndex.value].range[0].pattern == ""){
      if( masterFlow[currentMainIndex.value].range[0].min != "" &&
          masterFlow[currentMainIndex.value].range[0].max != "" ){
        if(answerController.text.isNotEmpty){
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
      }else{
        incrementForMainFlow();
        return;
      }
    }


    if (masterFlow[currentMainIndex.value].isMandatory == "true" &&
        masterFlow[currentMainIndex.value].selectedGroup != "Vitals") {
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
    if (masterFlow[currentMainIndex.value].isMandatory == "false" &&
        masterFlow[currentMainIndex.value].selectedGroup != "Vitals") {
      ///VALIDATIONS
      if (answerController.text.isEmpty || answerController.text.isNotEmpty) {
        incrementForMainFlow();
        return;
      }
    }
  }
  ///UPDATE UI ACCORDING TO THE SELECTED MODE OF THE QUESTION
 Widget updateUi(BuildContext context){

    switch(masterFlow[currentMainIndex.value].selectedMode){
      case "textEditor":{
        return TitleTextField(
          title: masterFlow[currentMainIndex.value].text,
          keyboardType: TextInputType.text,
          hint: '${masterFlow[currentMainIndex.value].text}',
          labelText: '${masterFlow[currentMainIndex.value].text}',
          controller: answerController,
        );
      }
      case "isNumeric":{
        return TitleTextField(
          title: masterFlow[currentMainIndex.value].text,
          keyboardType: TextInputType.number,
          hint: '${ masterFlow[currentMainIndex.value].text}',
          labelText: '${ masterFlow[currentMainIndex.value].text}',
          controller: answerController,
        );
      }
      case "isOptions":{
        options = masterFlow[currentMainIndex.value].options.split("#");

        if (options.length == 2) {
          // Display options in a row without radio buttons
          if (masterFlow[currentMainIndex.value].text == "Gender") {
            if (isNewPatient.value == false) {
              return SizedBox(
                width: ScreenSize.width(context) * 0.8,
                child: Obx(
                      () => ChipsChoice<int>.single(
                    choiceStyle: C2ChipStyle.filled(
                      foregroundStyle: TextStyle(
                          color: AppColor.blackMild,
                          fontSize: ScreenSize.width(context) * 0.04,
                          fontWeight: FontWeight.bold),
                      height: ScreenSize.height(context) * 0.05,
                      foregroundColor: AppColor.primaryColor,
                      color: AppColor.greyShimmer,
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width(context) * 0.04,
                      ),
                      selectedStyle: const C2ChipStyle(
                        backgroundColor: AppColor.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    value: optionsChoiceIndex.value,
                    onChanged: (val) {
                      showToast("CAN NOT UPDATE GENDER FOR FOLLOW UP PATIENT",
                          ToastGravity.CENTER);
                    },
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v.toUpperCase(),
                    ),
                    wrapped: false,
                  ),
                ),
              );
            } else {
              return SizedBox(
                width: ScreenSize.width(context) * 0.8,
                child: Obx(
                      () => ChipsChoice<int>.single(
                    choiceStyle: C2ChipStyle.filled(
                      foregroundStyle: TextStyle(
                          color: AppColor.blackMild,
                          fontSize: ScreenSize.width(context) * 0.04,
                          fontWeight: FontWeight.bold),
                      height: ScreenSize.height(context) * 0.05,
                      foregroundColor: AppColor.primaryColor,
                      color: AppColor.greyShimmer,
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width(context) * 0.04,
                      ),
                      selectedStyle: const C2ChipStyle(
                        backgroundColor: AppColor.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    value: optionsChoiceIndex.value,
                    onChanged: (val) {
                      print("THIS IS VALUE $val");
                      saveValueToAnswerController();

                      //showToast("THIS IS VALUE $val", ToastGravity.CENTER);

                      ///UPDATES QUESTIONS CHOICES
                      updateOptionsChoice(
                          options: options, index: val);
                    },
                    choiceItems: C2Choice.listFrom<int, String>(
                      source: options,
                      value: (i, v) => i,
                      label: (i, v) => v.toUpperCase(),
                    ),
                    wrapped: false,
                  ),
                ),
              );
            }
          } else {
            return SizedBox(
              width: ScreenSize.width(context) * 0.8,
              child: Obx(
                    () => ChipsChoice<int>.single(
                  choiceStyle: C2ChipStyle.filled(
                    foregroundStyle: TextStyle(
                        color: AppColor.blackMild,
                        fontSize: ScreenSize.width(context) * 0.04,
                        fontWeight: FontWeight.bold),
                    height: ScreenSize.height(context) * 0.05,
                    foregroundColor: AppColor.primaryColor,
                    color: AppColor.greyShimmer,
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenSize.width(context) * 0.04,
                    ),
                    selectedStyle: const C2ChipStyle(
                      backgroundColor: AppColor.primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  value: optionsChoiceIndex.value,
                  onChanged: (val) {
                    print("THIS IS VALUE $val");
                    saveValueToAnswerController();

                    //showToast("THIS IS VALUE $val", ToastGravity.CENTER);

                    ///UPDATES QUESTIONS CHOICES
                    updateOptionsChoice(
                        options: options, index: val);
                  },
                  choiceItems: C2Choice.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v.toUpperCase(),
                  ),
                  wrapped: false,
                ),
              ),
            );
          }
        } else {
          ///DISPLAY OPTIONS OF RADIO BUTTON IN A COLUMN
          return SizedBox(
            width: ScreenSize.width(context) * 0.8,
            height: ScreenSize.height(context) * 0.75,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose one Answer",
                    style: TextStyle(
                      fontSize: ScreenSize.width(context) * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blackMild,
                    ),
                  ),

                  const SizedBox(
                      height:
                      10), // Add some spacing between the text and options

                  ...List.generate(
                    options.length,
                        (index) => RadioListTile<int>(
                      value: index,
                      groupValue: optionsChoiceIndex.value,
                      onChanged: (val) {
                        debugPrint("Selected value: $val");
                        updateOptionsChoice(
                          options: options,
                          index: index,
                        );
                      },
                      title: Text(
                        options[index].toUpperCase(),
                        style: TextStyle(
                          fontSize: ScreenSize.width(context) * 0.04,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackMild,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      case "isDateField":{
        return masterFlow[currentMainIndex.value].text == "Select Date of Birth"
            ? Obx(() => isNewPatient.value
            ?

        ///NEW PATIENT - TAKES REGISTRATION
        Column(
          children: [
            Row(
              children: [
                /// TEXT FIELD FOR THE YEAR TEXT FIELD
                Expanded(
                  child: TitleTextField(
                    title: "Years",
                    hint: "Years",
                    labelText: "Years",
                    keyboardType: TextInputType.number,
                    len: 3,
                    controller: answerYearsController,
                  ),
                ),

                /// TEXT FIELD FOR THE MONTH TEXT FIELD
                Expanded(
                  child: TitleTextField(
                    title: "Months",
                    hint: "Months",
                    labelText: "Months",
                    keyboardType: TextInputType.number,
                    len: 2,
                    controller: answerMonthsController,
                  ),
                ),

                /// TEXT FIELD FOR THE DAY TEXT FIELD
                Expanded(
                  child: TitleTextField(
                    title: "Days",
                    hint: "Days",
                    labelText: "Days",
                    keyboardType: TextInputType.number,
                    len: 2,
                    controller: answerDaysController,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () async {
                        /// SHOW DATE PICKER
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          final now = DateTime.now();

                          /// FIND THE AGE BASED ON THE CURRENT AGE AND THE DATE OF BIRTH
                          // Calculate the difference between the two dates
                          Duration difference =
                          now.difference(pickedDate);

                          // Calculate the years, months, and days
                          int years = difference.inDays ~/ 365;
                          int months =
                              ((difference.inDays % 365) ~/ 30) % 12;
                          int days = (difference.inDays % 365) % 30;

                          // Update years if months reach 12
                          if (months == 12) {
                            years++;
                            months = 0;
                          }

                          /// UPDATE THE VALUES IN THE TEXT FIELD
                          /// YEAR CONTROLLER
                          answerYearsController
                              .text = years.toString();

                          /// MONTH CONTROLLER
                          answerMonthsController
                              .text = months.toString();

                          /// DAY CONTROLLER
                          answerDaysController
                              .text = days.toString();


                          selectedDateDob = pickedDate;

                        } else {

                        }
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        radius: 25,
                        child: Icon(
                          Icons.calendar_month,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        )
            :

        ///DOESN'T ALLOW YOU TO EDIT IF THE PATIENT IS ALREADY REGISTERED
        GestureDetector(
          onTap: () {
            showToast("can not edit already existing patient age", ToastGravity.TOP);
          },
          child: Container(
            height: ScreenSize.height(context) * 0.075,
            width: ScreenSize.width(context) * 0.9,
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.only(
                left: ScreenSize.width(context) * 0.01,
                right: ScreenSize.width(context) * 0.01),
            padding: EdgeInsets.only(
                left: ScreenSize.width(context) * 0.01,
                right: ScreenSize.width(context) * 0.01,
                top: ScreenSize.height(context) * 0.01,
                bottom: ScreenSize.height(context) * 0.01),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  //"${DateFormat("dd MMM yyyy").format(DateFormat("MMMM d, yyyy hh:mm:ss a").parse(userController.personalQuestionsModel.dob!)).toUpperCase()}",
                  //"${questionsController.dobFollowUp.value}",
                  "CAN NOT EDIT AGE",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: AppColor.tertiaryColor),
                ),
              ),
            ),
          ),
        ))
            :
              /// TEXT FIELD FOR THE YEAR TEXT FIELD
        Column(
          children: [
            Row(
              children: [
                Checkbox(value : isSelected.value , onChanged:(bool? value){
                  isSelected.value = value!;
                  answerController.text = isSelected.value ? DateFormat('dd MMM yyyy').format(DateTime.now()) : "";
                  update();
                }),
                /// TEXT FIELD FOR THE YEAR TEXT FIELD
                Expanded(
                  child: TitleTextField(
                    title: "Select date",
                    hint: "Select Check Box If Vaccine is Given",
                    // labelText: "Selected Date",
                    keyboardType: TextInputType.number,
                    len: 3,
                    controller: answerController,
                    enabled: isSelected.value ? true : false,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () async {
                        /// SHOW DATE PICKER
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now());

                        selectedDate = pickedDate!;
                        answerController.text =  isSelected.value ? DateFormat('dd MMM yyyy').format(selectedDate) : "";
                        update();
                      },
                      child: isSelected.value ? const CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        radius: 25,
                        child: Icon(
                          Icons.calendar_month,
                          color: AppColor.white,
                        ),
                      ) : Container(height: 1,),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }
      case "isDateTimeField":{
        ///ASSIGNING BY DEFAULT
        final defaultDateString = DateFormat('MMM dd , yyyy hh:mm:ss a').format(
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 0, 0, 0));

        return Column(
          children: [
            Row(
              children: [
                Container(
                  height: ScreenSize.height(context) * 0.075,
                  width: ScreenSize.width(context) * 0.68,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.only(
                      left: ScreenSize.width(context) * 0.01,
                      right: ScreenSize.width(context) * 0.01),
                  padding: EdgeInsets.only(
                      left: ScreenSize.width(context) * 0.01,
                      right: ScreenSize.width(context) * 0.01,
                      top: ScreenSize.height(context) * 0.01,
                      bottom: ScreenSize.height(context) * 0.01),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: AutoSizeText(
                       answerController.text == ""
                            ? defaultDateString
                            : formattedDate.value,
                        minFontSize: 14.0,
                        maxFontSize: 32.00,
                        style: const TextStyle(
                            fontSize: 20.00,
                            fontWeight: FontWeight.w500,
                            color: AppColor.tertiaryColor),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () async {
                        ///TOAST MESSAGE FOR ANC VISIT DATE
                        if (masterFlow[currentMainIndex.value].text == "ANC Visit Date") {
                          showToast(
                              "Visit Date is today's date by default. Can not make changes",
                              ToastGravity.CENTER);
                          return;
                        } else {
                          /// SHOW DATE PICKER
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            formattedDate.value =
                            DateFormat('MMM dd , yyyy hh:mm:ss a').format(
                                DateTime(pickedDate.year, pickedDate.month,
                                    pickedDate.day, 0, 0, 0));


                             answerController.text = formattedDate.value;
                             update();
                          } else {
                            ///ASSIGNING DEFAULT DATE

                              answerController.text =
                                  DateFormat('MMM dd, yyyy hh:mm:ss a').format(
                                      DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day,
                                          0,
                                          0,
                                          0));
                            update();
                          }
                        }
                      },
                      child: const CircleAvatar(
                        backgroundColor: AppColor.primaryColor,
                        radius: 25,
                        child: Icon(
                          Icons.calendar_month,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      }
      case "duration":{
        return Row(
          children: [
            /// DURATION QUESTION TEXT FIELD WITH THE DROPDOWN BUTTON
            Expanded(
              //width: ScreenSize.width(context) * 0.5,
              child: TitleTextField(
                title: masterFlow[currentMainIndex.value].text,
                keyboardType: TextInputType.phone,
                hint: '${masterFlow[currentMainIndex.value].text}',
                labelText: '${masterFlow[currentMainIndex.value].text}',
                controller: answerController,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                top: 25,
              ),
              child: SizedBox(
                height: ScreenSize.height(context) * 0.05,
                width: ScreenSize.height(context) * 0.1,
                child: DropdownButton<String>(
                  underline: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColor.primaryColor, width: 0.5)),
                  ),
                  value: selectedDateRangeFormat.value,

                  /// OPTION VALUES IN THE DROPDOWN FIELD
                  items: <String>['days', 'weeks', 'months', 'years']
                      .map<DropdownMenuItem<String>>(
                        (String option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (String? newValue) {

                      selectedDateRangeFormat.value =
                      newValue!;


                    /// TODO SET STATE MUST BE REMOVE FROM HERE
                    /// SELECTED VALUE REFLECT IN THE TEXT FIELD FOR THE DURATION QUESTIONS
                    // setState(() {
                    //   questionsController.answerController.text = '${questionsController.answerController.text} ${finalValue!}';
                    // });
                  },
                ),
              ),
            ),

            const SizedBox(
              width: 10,
            ),
          ],
        );
      }
      case "isMultiOptions":{
        List<String> multiOptions = masterFlow[currentMainIndex.value].options.split("#");

        return Obx(() => multiOptionsString.value == ""
            ?

        ///SELECT ITEMS
        GestureDetector(
          onTap: () async {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return MultiOptionsBottomSheet(
                    items: multiOptions,
                    selectedItems : multiOptionsStringList, // Pass the selected items here
                    onSave: (selectedItems) {

                        updateListToStringForMultiOptions(
                            selectedOptions: selectedItems);
                    update();
                    },
                  );
                });
          },
          child: Container(
            height: ScreenSize.height(context) * 0.075,
            width: ScreenSize.width(context) * 0.9,
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.only(
                left: ScreenSize.width(context) * 0.01,
                right: ScreenSize.width(context) * 0.01),
            padding: EdgeInsets.only(
                left: ScreenSize.width(context) * 0.01,
                right: ScreenSize.width(context) * 0.01,
                top: ScreenSize.height(context) * 0.01,
                bottom: ScreenSize.height(context) * 0.01),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "TAP TO CHOOSE OPTIONS",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.tertiaryColor),
              ),
            ),
          ),
        )
            :

        ///SELECTED ITEMS
        GestureDetector(
          onTap: () async {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return MultiOptionsBottomSheet(
                    items: multiOptions,
                    selectedItems: multiOptionsStringList, // Pass the selected items here
                    onSave: (selectedItems) {

                        updateListToStringForMultiOptions(
                            selectedOptions: selectedItems);
                        update();
                    },
                  );
                });
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: ScreenSize.width(context) * 0.01,
            ),
            padding: EdgeInsets.all(
              ScreenSize.width(context) * 0.01,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: multiOptionsStringList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${multiOptionsStringList[index]}\n",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
      }
      case "":{
        return TitleTextField(
          title: masterFlow[currentMainIndex.value].text,
          keyboardType: TextInputType.text,
          hint: '${masterFlow[currentMainIndex.value].text}',
          labelText: '${masterFlow[currentMainIndex.value].text}',
          controller: answerController,
        );
      }
    }
    return Container(
      color: Colors.teal,
    );
  }

  //UPDATE OPTIONS SINGLE STRING TO
  updateListToStringForMultiOptions({List<String>? selectedOptions}) {
    String finalSelectedOptions = "";

    for (int i = 0; i < selectedOptions!.length; i++) {
      if (i == selectedOptions.length - 1) {
        finalSelectedOptions = "$finalSelectedOptions${selectedOptions[i]}";
      } else {
        finalSelectedOptions = "$finalSelectedOptions${selectedOptions[i]}#";
      }
    }

    multiOptionsStringList = selectedOptions;
    multiOptionsString.value = finalSelectedOptions.replaceAll("\t", "");
    update();
  }

  ///UPDATES OPTION CHOICE INDEX AND VALUE
  updateOptionsChoice({required List<String> options, required int index}) {
    optionsChoiceIndex.value = index;
    optionsChoiceTag.value = options[optionsChoiceIndex.value].toLowerCase();
    update();
  }


  ///SAVE THE SELECTED VALUE TO ANSWER CONTROLLER
  saveValueToAnswerController(){
    for(int i = 0 ; i < options.length; i++){
      if(i == optionsChoiceIndex.value){
        print("value before ${answerController.text}");
        answerController.text = options[i];
        print("value before ${answerController.text}");
        update();
      }
    }
  }
///PRELOAD ANSWERS FOR EDITING
  preLoadAnswersForEditing({required Elements currentElement}) {
    //print("THIS IS TEST IN PRE-LOAD QUESTIONS METHOD ${currentElement.text}   ${currentElement.answer}");

    switch (currentElement.selectedMode) {
      case "textEditor":
        if (currentElement.answer != null && currentElement.answer != "") {
          answerController.text = currentElement.answer!;
        }

        break;

      case "isNumeric":
        if (currentElement.answer != null && currentElement.answer != "") {
          if (currentElement.text == "Select Date of Birth") {
            double combinedDate = double.parse(currentElement.answer!);

            int years =
            combinedDate.toInt(); //Extract the integer part as years
            double remainingMonthsAndDays =
                combinedDate - years; //Get the fractional part

            int months = (remainingMonthsAndDays * 12)
                .toInt(); //Convert months to an integer
            double remainingDays = (remainingMonthsAndDays * 12 - months) *
                30; //Convert remaining months to days

            int days = remainingDays.toInt(); //Convert days to an integer

            answerDaysController.text = days.toString();
            answerMonthsController.text = months.toString();
            answerYearsController.text = years.toString();
          } else if (currentElement.text == "Enter Mobile Number") {
            if (currentElement.answer?.length != 10) {
              answerController.text = currentElement.answer!.replaceAll("+91-", "");
            } else {
              answerController.text = currentElement.answer!;
            }
          } else {
            answerController.text = currentElement.answer!;
          }
        }

        break;

      case "isDateField":
        if (currentElement.answer != null && currentElement.answer != "") {
          DateTime date =
          DateFormat("dd MMM yyyy").parse(currentElement.answer!);

          int days = date.day;
          int months = date.month;
          int years = date.year;

          answerDaysController.text = days.toString();
          answerMonthsController.text = months.toString();
          answerYearsController.text = years.toString();
        } else {
          answerDaysController.text = "0";
          answerMonthsController.text = "0";
          answerYearsController.text = "0";
        }

        break;

      case "duration":
        if (currentElement.answer != null && currentElement.answer != "") {
          if (currentElement.answer!.split(" ").length != 0) {
            answerController.text = currentElement.answer!.split(" ")[0];
           selectedDateRangeFormat.value =
                currentElement.answer!.split(" ")[1].toLowerCase();
          }
        }
        break;

      case "isOptions":
        if (currentElement.answer != null && currentElement.answer != "") {
          List optionsList = currentElement.options!.split("/");

          for (int index = 0; index < optionsList.length; index++) {
            if (optionsList[index] == currentElement.answer) {
              optionsChoiceTag.value =
                  optionsList[index].toString().toLowerCase();
              optionsChoiceIndex.value = index;
            }
          }
        }

        break;

      case "isMultiOptions":
        if (currentElement.answer != null && currentElement.answer != "") {
          multiOptionsString.value = currentElement.answer!;
          multiOptionsStringList = currentElement.answer!.split("#");
        }

        break;

      default:
        if (currentElement.answer != null && currentElement.answer != "") {
          answerController.text = currentElement.answer!;
        }
        break;
    }

    update();
  }
}
