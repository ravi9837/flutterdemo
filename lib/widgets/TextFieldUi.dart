import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/widgets/titleTextField.dart';
import 'package:get/get.dart';

class TextEditorUiPage extends GetView<FlowController> {
  const TextEditorUiPage({super.key});

  ///FUNCTION FOR CLOSING THE KEYBOARD AFTER EACH QUESTION
  closeKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TitleTextField(
      title: controller.masterFlow[controller.currentMainIndex.value].text,
      keyboardType: TextInputType.text,
      hint: '${controller.masterFlow[controller.currentMainIndex.value].text}',
      labelText: '${controller.masterFlow[controller.currentMainIndex.value].text}',
      controller: controller.answerController,
    );
  }
}


