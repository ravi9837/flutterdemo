import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/constants/appColors.dart';
import 'package:flutterdemo/constants/screenSize.dart';
import 'package:get/get.dart';
import 'package:flutterdemo/globals.dart' as global;

class QuestionPage extends GetView<FlowController> {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          backButtonWidgetUI(context: context, onTap: () { controller.decrementForMainFlow(); }),
                          sendButton(context: context, onTap: () { controller.checkMandatory(); }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => controller.masterFlow.isNotEmpty ?
                              Expanded(
                                child: mainQuestionCard(context)
                              )
            :
                          const Text(""),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                      width: 500,
                      child:
                      Obx(() => controller.updateUi(context)
                      )
                  )
                ]
            )
        )
    );
  }

  mainQuestionCard(BuildContext context){
    if(controller.masterFlow[controller.currentMainIndex.value].selectedGroup != "Immunization"){
      return Card(
          child:
          Text(
            "TEXT : ${controller.masterFlow[controller.currentMainIndex.value].text}",
            maxLines: 3,
            textAlign: TextAlign.center,
          )
      );
    }
    else if (controller.masterFlow[controller.currentMainIndex.value].selectedGroup == "Immunization"){
      List<String> segments = controller.masterFlow[controller.currentMainIndex.value].text.split('*');
     return Column(
       children: [
         ///UI FOR HEADERS
         showUiForImmunizationFLow(
             mainList: global.headers,
             height: 40,
             color: Colors.purple.withOpacity(0.2),
             borderColor: Colors.black,
             fontSize: 18,
             fontWeight: FontWeight.bold
         ),
         ///UI FOR THE QUESTIONS IN IMMUNIZATION FLOWCHART
         showUiForImmunizationFLow(
           mainList: segments,
           height: 100,
           color: Colors.white,
           borderColor: Colors.black, )
       ],
     );
    }
    return Container(
      height: 1,
    );
  }

  Widget showUiForImmunizationFLow({
    required List<String> mainList,
    required double height,
    required Color color,
    required Color borderColor,
    double? fontSize,
    FontWeight? fontWeight
  }){
    return Column(
      children: [
        Card(
          shape: const RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.black
            ),
          ),
          child: Row(
              children: [
                ...mainList.map((segment) =>
                    Expanded(
                      child:
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          height: height,
                          // padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            color: color
                          ),
                          child: Center(child: AutoSizeText(
                            segment,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: fontWeight),
                          )
                          ),
                        ),
                      ),
                    )
                ).toList(),
              ]
          ),
        ),
      ],
    );
  }


  ///SEND BUTTON
  Widget sendButton({required BuildContext context, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: ScreenSize.width(context) * 0.075,
          height: ScreenSize.height(context) * 0.06,
          decoration: BoxDecoration(
            color: AppColor.primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 25.0,
            color: AppColor.blackMild,
          ),
        ),
      ),
    );
  }

  ///BACK BUTTON WIDGET - UI
  Widget backButtonWidgetUI({Color? buttonColor , required BuildContext context,required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          width: ScreenSize.width(context) * 0.075,
          height: ScreenSize.height(context) * 0.06,
          decoration: BoxDecoration(
            // color: buttonColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Icon(
            Icons.arrow_back_ios,
            size: 25.0,
            color: AppColor.blackMild,
          ),
        ),
      ),
    );
  }
}
