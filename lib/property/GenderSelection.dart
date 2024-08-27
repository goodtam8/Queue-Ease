import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final String initialOption;
  final Function(String) onGenderSelected;

  GenderSelectionWidget({required this.initialOption, required this.onGenderSelected});

  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  late String currentOption;

  @override
  void initState() {
    super.initState();
    currentOption = widget.initialOption;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ListTile(
            title: const Text('Men'),
            leading: Radio<String>(
              value: 'Men',
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value!;
                  widget.onGenderSelected(currentOption);
                });
              },
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.red; // Change this color as needed for selected state
                }
                return Colors.grey; // Change this color as needed for unselected state
              }),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Women'),
            leading: Radio<String>(
              value: 'Women',
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value!;
                  widget.onGenderSelected(currentOption);
                });
              },
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.red; // Change this color as needed for selected state
                }
                return Colors.grey; // Change this color as needed for unselected state
              }),
            ),
          ),
        ),
      ],
    );
  }
}