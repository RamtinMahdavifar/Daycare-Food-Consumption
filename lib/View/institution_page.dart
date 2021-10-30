import 'package:flutter/material.dart';
import 'food_status_page.dart';
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
    return Scaffold(
        appBar: AppBar(title: Text(widget.institutionName.toString()), leading: backButton(context), actions: [modifyButton()]),
        body: _InstitutionOptions(),
      );
  }


  Widget _InstitutionOptions(){
      return SafeArea(

          child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  <Widget>[
              Flexible(
                child: Text("Address: " + widget.institutionAddress, style: TextStyle(fontSize: 40))
              ),
              Expanded(
                child: Padding(padding: EdgeInsets.all(10),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //most of the buttons do not navigate anywhere and have null as their navigation parameter
                        menuButton(context,"Roster", () => UploadData(), 2),
                        SizedBox(width: 50),
                        menuButton(context,"Preset", () => UploadData(), 0),
                      ],

                    )),
                
              ),
              Expanded(
                child: Padding(padding: EdgeInsets.all(10),
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //most of the buttons do not navigate anywhere and have null as their navigation parameter
                        menuButton(context,"View Data", () => UploadData(), 3),
                        SizedBox(width: 50),
                        menuButton(context,"Input Data", () => FoodStatusPage(), 1),
                      ],

                    )),

              ),
            ],
          )
      ),);
      }
}
