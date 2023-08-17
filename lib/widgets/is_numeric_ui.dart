import 'package:flutter/material.dart';
import 'package:flutterdemo/Controller/flowController.dart';
import 'package:flutterdemo/constants/appColors.dart';
import 'package:flutterdemo/constants/screenSize.dart';
import 'package:flutterdemo/widgets/titleTextField.dart';
import 'package:flutterdemo/widgets/toastMessage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class IsNumericUiPage extends GetView<FlowController> {
  const IsNumericUiPage({super.key});

  ///FUNCTION FOR CLOSING THE KEYBOARD AFTER EACH QUESTION
  closeKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    currentFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return controller.masterFlow[controller.currentMainIndex.value].text == "Select Date of Birth"
        ? Obx(() => controller.isNewPatient.value
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
                    controller: controller.answerYearsController,
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
                    controller: controller.answerMonthsController,
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
                    controller: controller.answerDaysController,
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
                          controller.answerYearsController
                              .text = years.toString();

                          /// MONTH CONTROLLER
                          controller.answerMonthsController
                              .text = months.toString();

                          /// DAY CONTROLLER
                          controller.answerDaysController
                              .text = days.toString();


                          controller.selectedDateDob = pickedDate;

                        } else {}
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              //"${DateFormat("dd MMM yyyy").format(DateFormat("MMMM d, yyyy hh:mm:ss a").parse(userController.personalQuestionsModel.dob!)).toUpperCase()}",
              //"${questionsController.dobFollowUp.value}",
              "CAN NOT EDIT AGE",
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: AppColor.tertiaryColor),
            ),
          ),
        ),
      ),
    ))
        : TitleTextField(
      title: controller.masterFlow[controller.currentMainIndex.value].text,
      hint: '${controller.masterFlow[controller.currentMainIndex.value].text}',
      labelText: '${controller.masterFlow[controller.currentMainIndex.value].text}',
      keyboardType: TextInputType.phone,
      len: int.tryParse(controller.masterFlow[controller.currentMainIndex.value].range[0].length),
      controller: controller.answerController,
      //onSubmit: (val) => questionsController.answerController.text.length != elements.selectedLength ? showToast("Please enter ${elements.selectedLength} digits", ToastGravity.CENTER) : null,
    );








    //   Scaffold(
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Obx(() =>
    //         controller.masterFlow.isNotEmpty
    //             ? Text(
    //             "TEXT : ${controller.masterFlow[controller.currentMainIndex
    //                 .value].text}")
    //             : const Text("")),
    //         SizedBox(
    //           width: 100,
    //           child: TextField(
    //             controller: controller.answerController,
    //             decoration: InputDecoration(
    //               hintText: "ANSWER",
    //               errorText: controller.validate.value
    //                   ? "value can't be null"
    //                   : null,
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: [
    //             ElevatedButton(
    //                 onPressed: () {
    //                   controller.decrementForMainFlow();
    //                 },
    //                 child: const Icon(Icons.arrow_back)),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             ElevatedButton(
    //                 onPressed: () {
    //                   // controller.answerController.text.isEmpty ?
    //                   // controller.validate.value = true :
    //                   // controller.validate.value = false;
    //
    //                   // controller.validate.value == false ?
    //                   controller.checkMandatory();
    //                   // :
    //                   // null;
    //
    //                   closeKeyBoard(context);
    //                 },
    //                 child: const Icon(Icons.arrow_forward)),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             ElevatedButton(
    //                 onPressed: () {
    //
    //                 },
    //                 child: const Icon(Icons.arrow_back_ios_new_rounded)),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             const SizedBox(
    //               height: 10,
    //             ),
    //             ElevatedButton(
    //                 onPressed: () {
    //
    //                 },
    //                 child: const Icon(Icons.add)),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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


