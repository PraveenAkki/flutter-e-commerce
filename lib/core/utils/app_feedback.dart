import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppFeedback {
  const AppFeedback._();

  static void toast(String message) =>
      Fluttertoast.showToast(msg: message, gravity: ToastGravity.BOTTOM);

  static void error(BuildContext context, String message) {
    Flushbar<void>(
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.red.shade700,
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    ).show(context);
  }
}