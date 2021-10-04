// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_app/Widgets/InputForm.dart';

class HomePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Prototype WIP")),
        body: InputForm()/*Row(children: [
          InputForm()
        ])*/

    );
  }

}