import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/View/login_page.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

class PlateWasteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building app...");
    return MaterialApp(
        title: 'Plate Waste Tracker',
        theme: ThemeData(
          // explicitly define theme data here ie colours, fonts, style etc
          primarySwatch: Colors.blue,
        ),
        home: LoginPage()
    );
  }
}


void main() {
  Config.log.i("running main() of main.dart, initializing app and going to home page...");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PlateWasteApp());
}

