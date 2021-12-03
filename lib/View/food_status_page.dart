import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

import 'food_status_widget.dart';
import 'id_input_page.dart';
import 'institution_page_widgets.dart';

class FoodStatusPage extends StatefulWidget {
  ///Page to show option for uneaten, eaten and container
  ///So that user can select the correct option to record the food item weight

  FoodStatusPage({Key? key}) : super(key: key);

  @override
  State<FoodStatusPage> createState() => _FoodStatusPageState();
}

class _FoodStatusPageState extends State<FoodStatusPage> {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building food status page");
    return Scaffold(
      appBar: AppBar(
          title: Text('Select the food status'),
          leading: backButton(context),
          actions: [modifyButton()]),
      body: _FoodStatusOptions(),
    );
  }

  Widget _FoodStatusOptions() {
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Once user click on button they are redirected to ID_inputpage
          //to record the data
          foodStatusButton(context, "uneaten", () => ID_InputPage()),
          foodStatusButton(context, "eaten", () => ID_InputPage()),
          foodStatusButton(context, "container", () => ID_InputPage()),
        ],
      ))),
    );
  }
}
