import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Topbar(),
      
      body: Text("It is analysis screen"),
    );
  }
}