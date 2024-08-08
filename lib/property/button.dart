import 'package:flutter/material.dart';

class Styled_button extends StatelessWidget {
  const Styled_button({super.key,
  required this.onPressed,
  required this.child
  });
  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed,style:  ElevatedButton.styleFrom(backgroundColor: Colors.blue[800],
    
    ), child: child,);
  }
}