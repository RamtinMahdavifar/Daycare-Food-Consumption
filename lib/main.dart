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
          textTheme: const TextTheme(
            // headline6 is used for text displayed on the top appbar among other things
            headline6: TextStyle(fontSize: 28.0),
            // subtitle1 is used for text in text fields and text input fields
            subtitle1: TextStyle(fontSize: 24.0),
          ),
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

