import 'package:flutter/material.dart';

import 'select_institution_widgets.dart';

class ChooseInstitute extends StatefulWidget {
  @override
  State<ChooseInstitute> createState() => _ChooseInstituteState();
}

class _ChooseInstituteState extends State<ChooseInstitute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plate Waste Tracker')),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: <Widget>[
            // TODO: move these child widgets to their own files
            addInstitution(context),
            searchInstitution(),
            //_buildList(),
            institutionDisplay(context),
            quickfixButton(context)
          ])),
    );
  }
}
