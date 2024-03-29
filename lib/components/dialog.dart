import 'package:flutter/material.dart';

import '../../shared/theme.dart';

void customDialog(String title, String subtitle, String type,
    VoidCallback onPressed, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            width: 290,
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: neutral100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: onPressed, icon: const Icon(Icons.close)),
                ),
                type == 'Success'
                    ? Image.asset(
                        'assets/img_success.png',
                        width: 150,
                      )
                    : Image.asset(
                        'assets/img_failed.png',
                        width: 150,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: 190,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: poppins.copyWith(
                          fontWeight: semiBold,
                          fontSize: 16,
                          color: neutral600),
                    ),
                  ),
                ),
                SizedBox(
                  width: 190,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: poppins.copyWith(fontSize: 12, color: neutral600),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        );
      });
}
