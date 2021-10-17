import 'package:flutter/material.dart';
import 'institution_page_widgets.dart';
import 'upload_data.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

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
    Config.log.i("building institution page");
    return MaterialApp(
        title: 'institution page',
        home: Scaffold(
        appBar: AppBar(title: Text(widget.institutionName.toString()), leading: backButton(context), actions: [modifyButton()]),
        body: _InstitutionOptions()
      )
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
                    //most of the buttons do not navigate anywhere and have null as their navigation parameter
                    menuButton(context, "QR Code", () => UploadData()),
                    menuButton(context, "Camera", () => UploadData()),
                    menuButton(context, "Roster", () => UploadData()),
                  ],

                )
              ),
              Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      menuButton(context, "Record Data", () => UploadData()),
                      menuButton(context, "View Data", () => UploadData()),
                      menuButton(context, "Food", () => UploadData()),
                    ],

                  )
              ),
            ],
          )
      );
      }
}
