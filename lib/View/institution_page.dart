import 'package:flutter/material.dart';
import 'widgets.dart' as btn;

class InstitutionPage extends StatefulWidget {
  String institutionName;
  String institutionAddress;

  InstitutionPage(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);

  @override
  State<InstitutionPage> createState() => _InstitutionPageState();
}

class _InstitutionPageState extends State<InstitutionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.institutionName.toString()), leading: btn.BackButton(context), actions: [btn.modifyButton()]),
        body: _InstitutionOptions()
    );
  }

  Widget _InstitutionOptions(){
      return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  <Widget>[
              Flexible(
                child: Text("Address: " + widget.institutionAddress, style: TextStyle(fontSize: 25))
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    btn.MenuButton("QR Code"),
                    btn.MenuButton("Camera"),
                    btn.MenuButton("Roster"),
                  ],

                )
              ),
              Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      btn.MenuButton("Record Data"),
                      btn.MenuButton("View Data"),
                      btn.MenuButton("Food"),
                    ],

                  )
              ),
            ],

          )

      );
      }
}
