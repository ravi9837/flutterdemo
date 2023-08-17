import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
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
}


