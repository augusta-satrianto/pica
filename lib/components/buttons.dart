import 'package:flutter/material.dart';
import 'package:pica/shared/methods.dart';
import 'package:pica/shared/theme.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final String colorHex;
  const CustomElevatedButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.colorHex});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(hexToColor(colorHex)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        shadowColor: MaterialStateProperty.all<Color>(
          const Color.fromRGBO(0, 0, 0, 1),
        ),
        elevation: MaterialStateProperty.all<double>(4),
        minimumSize:
            MaterialStateProperty.all<Size>(const Size(double.infinity, 47)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: poppins.copyWith(
                color: Colors.white, fontSize: 18, fontWeight: semiBold),
          ),
        ],
      ),
    );
  }
}
