import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/navgationbar.dart';

class Sucessfulscan extends StatefulWidget {
  const Sucessfulscan({super.key});

  @override
  State<Sucessfulscan> createState() => _SucessfulscanState();
}

class _SucessfulscanState extends State<Sucessfulscan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCEDFF2), // Hex color code

      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150.0,
            ),
            Container(
              alignment: Alignment.center,
              width: 101,
              height: 101,
              decoration: BoxDecoration(
                color: Color(0xFF4A75A5),
                borderRadius: BorderRadius.circular(9999), // Fully rounded
              ),
              child: Container(
                  width: 65,
                  height: 65,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 65.0,
                  )),
            ),
            Text("You have Successful check in",
                style: TextStyle(
                  color: Color(0xFF4A75A5), // Color in Flutter format
                  fontSize: 24,
                  fontFamily:
                      'Open Sans', // Make sure to include this font in your pubspec.yaml
                  height: 1.33,
                )),
            Text("Time: ${DateTime.now()}",
                style: TextStyle(
                  color: Color(0xFF4A75A5), // Color in Flutter format
                  fontSize: 24,
                  fontFamily:
                      'Open Sans', // Make sure to include this font in your pubspec.yaml
                  height: 1.33,
                )),
            SizedBox(height: 50.0),
            ElevatedButton(
              onPressed: () {
                globalNavigationBarKey.currentState?.updateIndex(0);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: Color(0xFF4A75A5), // Background color
                textStyle: TextStyle(
                  fontSize: 16,
                  fontFamily:
                      'Open Sans', // Ensure this font is added in pubspec.yaml
                  fontWeight: FontWeight.w500,
                  height: 1.5, // lineHeight equivalent (24px/16px)
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // Border radius
                ),
              ),
              child: const Text(
                'Back to Home Page',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
