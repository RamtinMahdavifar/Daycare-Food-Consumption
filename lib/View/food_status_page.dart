import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'food_status_widget.dart';
import 'id_input_page.dart';
import 'institution_page_widgets.dart';
import 'qrcode.dart';
import 'id_input_page.dart';
import 'qr_scan_id.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';

class FoodStatusPage extends StatefulWidget {

  InstitutionInfo currentInstitution;
  FoodStatusPage(this.currentInstitution, {Key? key}) : super(key: key);

  @override
  State<FoodStatusPage> createState() => _FoodStatusPageState();
}

class _FoodStatusPageState extends State<FoodStatusPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building food status page");
    return Scaffold(
      appBar: AppBar(title: Text('Select the food status'), leading: backButton(context), actions: [modifyButton()]),
      body: _FoodStatusOptions(),
    );
  }


  Widget _FoodStatusOptions(){
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  <Widget>[
                  foodStatusButton(context,"uneaten",()=>ID_InputPage(widget.currentInstitution, FoodStatus.uneaten)),

                  foodStatusButton(context,"eaten",()=>ID_InputPage(widget.currentInstitution, FoodStatus.eaten)),

                  foodStatusButton(context,"container",()=>ID_InputPage(widget.currentInstitution, FoodStatus.container)),

                ],
              )
          )
      ),);
  }
}
