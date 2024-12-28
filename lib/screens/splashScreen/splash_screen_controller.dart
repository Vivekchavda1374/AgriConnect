import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreenController {
  final ValueNotifier<bool> animation = ValueNotifier<bool>(false);
  bool get animate => animation.value;

  Future<void> startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animation.value = true;
    await Future.delayed(const Duration(seconds: 3));
    animation.value = false;
  }
}
