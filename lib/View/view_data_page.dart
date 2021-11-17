import 'package:flutter/material.dart';

class ViewDataPage extends StatefulWidget {
  String institutionName;
  String institutionAddress;

  ViewDataPage(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);


  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            children:
        )
    );
  }
}
