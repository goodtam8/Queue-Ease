import 'package:flutter/material.dart';

class Styled_button extends StatelessWidget {
  const Styled_button(
      {super.key, required this.onPressed, required this.child});
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300.0,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4a75a5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    0), // Set borderRadius to 0 for rectangle shape
              ),
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
