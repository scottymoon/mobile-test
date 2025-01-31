import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:provider/provider.dart';
import 'package:qr_generator/models/seed.dart';

class Countdown extends StatefulWidget {
  final int timeOutInSeconds;

  Countdown(this.timeOutInSeconds);

  @override
  _CountdownState createState() => _CountdownState(timeOutInSeconds);
}

class _CountdownState extends State<Countdown> {
  CountdownTimer countdownTimer;
  StreamSubscription<CountdownTimer> sub;
  int timeOutInSeconds;
  final stepInSeconds = 1;
  int currentNumber = 1;

  _CountdownState(int timeOutInSeconds) {
    this.timeOutInSeconds = timeOutInSeconds;
  }

  @override
  void initState() {
    countdownTimer = new CountdownTimer(
      Duration(seconds: timeOutInSeconds),
      Duration(seconds: stepInSeconds),
    );

    sub = countdownTimer.listen(null);
    sub.onData((duration) {
      currentNumber += stepInSeconds;
      this.onTimerTick(currentNumber);
    });
    sub.onDone(() {
      sub.cancel();
      // when QR code expires, automagically fetch a new one.
      Provider.of<Seed>(context).fetchSeed();
    });

    super.initState();
  }

  void onTimerTick(int currentNumber) {
    setState(() {
      currentNumber = currentNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    int number = timeOutInSeconds - currentNumber;
    number += stepInSeconds;
    return Text(
      '$number seconds',
      style: TextStyle(
        fontSize: 25.0,
      ),
    );
  }

  @override
  void dispose() {
    sub.cancel();
    countdownTimer.cancel();
    super.dispose();
  }
}
