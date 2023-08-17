import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/constants/appColors.dart';
import 'package:flutterdemo/constants/screenSize.dart';
import 'package:get/get.dart';

class NothingUiPage extends GetView<FlowController> {
  const NothingUiPage({super.key});

  ///FUNCTION FOR CLOSING THE KEYBOARD AFTER EACH QUESTION
  closeKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child:Column(
        children: [
            TextField(
                controller: controller.answerController,
                decoration: InputDecoration(
                  hintText: "ANSWER",
                  errorText: controller.validate.value
                      ? "value can't be null"
                      : null,
                ),
                textAlign: TextAlign.center,
              ),

          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    controller.decrementForMainFlow();
                  },
                  child: const Icon(Icons.arrow_back)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    // controller.answerController.text.isEmpty ?
                    // controller.validate.value = true :
                    // controller.validate.value = false;

                    // controller.validate.value == false ?
                    // controller. vitalValidation();
                    controller.checkMandatory();
                    // :
                    // null;

                    closeKeyBoard(context);
                  },
                  child: const Icon(Icons.arrow_forward)),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {

                  },
                  child: const Icon(Icons.not_interested_sharp)),
            ],
          ),
        ],
      ),
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
            color: buttonColor!.withOpacity(0.5),
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


