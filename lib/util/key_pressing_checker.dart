import 'dart:async';

import 'package:flutter/material.dart';

class KeyPressingChecker {
  KeyPressingChecker({
    this.isPressing = false,
    this.timer,
  });
  bool isPressing;
  Timer? timer;

  setTimer(void Function() moveBlockCallBack) {
    timer = Timer(
      Durations.medium2,
      () {
        if (isPressing) {
          moveBlockCallBack();
        }
        timer = Timer.periodic(
          const Duration(
            milliseconds: 100,
          ),
          (_) {
            if (isPressing) {
              moveBlockCallBack();
            }
          },
        );
      },
    );
  }

  void get cancelTimer {
    timer?.cancel();
  }
}
