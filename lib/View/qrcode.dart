import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import "../Model/variables.dart";
import "camera_food2.dart";

class QRcode extends StatelessWidget {
  QRcode(this.qRdata);

  final String qRdata;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Flutter Demo Home Page')),
        body: QrImage(
            data: qRdata,
            version: QrVersions.auto,
            size: 430,
          )
    );
  }
}

