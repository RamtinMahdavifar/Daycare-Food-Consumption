import 'package:flutter/material.dart';
import 'roster_page.dart';
import 'food_status_widget.dart';
import 'id_input_page.dart';
import 'institution_page_widgets.dart';
import 'upload_data.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

class ViewDataPage extends StatefulWidget {


  ViewDataPage( {Key? key}) : super(key: key);

  @override
  State<ViewDataPage> createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building view data page");
    return Scaffold(
      appBar: AppBar(title: Text('Select the view data'), leading: backButton(context), actions: [modifyButton()]),
      body: _ViewDataPageOptions(),
    );
  }


  Widget _ViewDataPageOptions(){
    return SafeArea(

      child: Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  <Widget>[
                  foodStatusButton(context,"Scan QR",()=>ID_InputPage()),

                  foodStatusButton(context,"Roster",()=>Roster()),
                 //TODO: Added a new widget page for export data and replace it with the upload data stub
                  foodStatusButton(context,"Export All Data",()=>UploadData()),



                ],
              )
          )
      ),);
  }
}
