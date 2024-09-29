import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Restinfo extends StatefulWidget {
  const Restinfo({super.key});

  @override
  State<Restinfo> createState() => _Restinfostate();
}

class _Restinfostate extends State<Restinfo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Topbar(),
      body: Column(
        
      ),
    );
  }
}