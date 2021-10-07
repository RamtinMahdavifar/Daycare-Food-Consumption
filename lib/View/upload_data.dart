import 'package:flutter/material.dart';
import 'widgets.dart' as btn;

class UploadData extends StatefulWidget {
  //String institutionName;
  //String institutionAddress;

  UploadData({Key? key}) : super(key: key);

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Upload Data"), leading: btn.BackButton(context)),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
                children: [ //
                  btn.uploadImage(context),
                ])
        )
    );
  }
}