import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutterdemo/constants/screenSize.dart';


class CountDownTimerWidget extends StatefulWidget {
  const CountDownTimerWidget({super.key});

  @override
  _CountDownTimerWidgetState createState() => _CountDownTimerWidgetState();
}

class _CountDownTimerWidgetState extends State<CountDownTimerWidget> {
  int _secondsRemaining = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: ScreenSize.height(context) * 0.1,
      child: Center(
        child: Text(
          '$_secondsRemaining',
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
