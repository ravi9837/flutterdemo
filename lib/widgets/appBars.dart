import 'package:flutter/material.dart';
import 'package:flutterdemo/constants/appColors.dart';
import 'package:flutterdemo/constants/screenSize.dart';


titleAppBar(
    {required BuildContext context, String? title ,Widget? leading, List<Widget>? actions}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(50.0),
    child: Container(
      width: ScreenSize.width(context),



      decoration: const BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          )),
      child: AppBar(
        actions: actions ?? [],

        leading: leading ?? Container(height: 1,),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(30),
            right: Radius.circular(30),
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        centerTitle: true,
        title: Text(title ?? "",style: const TextStyle(color: AppColor.white),),
        elevation: 4,
      ),
    ),
  );
}


