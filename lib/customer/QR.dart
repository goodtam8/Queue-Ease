import 'package:flutter/material.dart';
import 'package:fyp_mobile/property/topbar.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Qr extends StatefulWidget {
  const Qr({super.key});

  @override
  State<Qr> createState() => _QrState();
}

class _QrState extends State<Qr> {
  String ?qrdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(),
      body: Column(children: [
TextField(onSubmitted: (value){
  setState(() {
    qrdata=value;
  });
  if(qrdata!=null){
    PrettyQrView.data(data: qrdata!);
  }
},)
      ],),
    );
  }
}