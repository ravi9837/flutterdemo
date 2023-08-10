import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
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
                  Obx(() => controller.masterFlow.isNotEmpty ?
                  Text("TEXT : ${controller.masterFlow[controller.currentMainIndex.value].text}") :
                  const Text("")
                  ),
                  SizedBox(
                      width: 500,
                      child: Obx(() => controller.updateUi()
                      )
                  )
                ]
            )
        )
    );
  }
}
