import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/constants/appColors.dart';
import 'package:flutterdemo/constants/screenSize.dart';
import 'package:get/get.dart';

class QuestionPage extends GetView<FlowController> {
  const QuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      backButtonWidgetUI(context: context),

                      Obx(() => controller.masterFlow.isNotEmpty ?
                      Text("TEXT : ${controller.masterFlow[controller.currentMainIndex.value].text}") :
                      const Text(""),

                      ),
                      sendButton(context: context),
                    ],
                  ),

                  SizedBox(
                      width: 500,
                      child: Obx(() => controller.updateUi(context)
                      )
                  )
                ]
            )
        )
    );
  }
  ///SEND BUTTON
  Widget sendButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () async {
        controller.incrementForMainFlow();
      },
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
  Widget backButtonWidgetUI({Color? buttonColor , required BuildContext context}) {
    return GestureDetector(
      onTap: () async {
        controller.decrementForMainFlow();
      },
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
