import 'package:flutter/material.dart';

Widget CustomCard(
    {required BuildContext context, var color, required double radius}) {
  return Card(
    elevation: 25,
    color: color,
    shadowColor: color,
    child: Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      height: MediaQuery.of(context).size.width * 0.2,
      width: MediaQuery.of(context).size.height * 0.1,
    ),
  );
}
