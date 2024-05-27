import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MyFlushbar {
  static void showFlushbar(BuildContext context, String message) {
    
    Flushbar(
      messageText: Row(
        children: [
          Image.asset(
            'assets/ic_warning.png',
            width: 13,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(21),
      padding: const EdgeInsets.all(10),
      backgroundColor: const Color(0xFFFD4C4C),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }
}
