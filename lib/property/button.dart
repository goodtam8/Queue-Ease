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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              fixedSize: const Size(295, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: const Color(0xFF1578E6), // Background color
              elevation: 0, // Remove shadow
            ),
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Source Sans Pro',
                fontWeight: FontWeight.w600,
                height: 29 / 16, // Line height
              ),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
