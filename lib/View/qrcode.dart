import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyHome extends StatelessWidget {
  MyHome(this.qRdata);

  final String qRdata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Flutter Demo Home Page')),
        body: QrImage(
          data: qRdata,
          version: QrVersions.auto,
          size: 430,
        ));
  }
}
