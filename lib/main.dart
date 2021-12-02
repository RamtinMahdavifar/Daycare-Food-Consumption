import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'View/roster_page.dart';
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
            // button is used for button style
            button: TextStyle(fontSize: 22.0),
            // caption text is used for error text displayed by input fields
            caption: TextStyle(fontSize: 18.0),
          ),
        ),
        home: Roster(),
    );
  }
}


void main() async{
  Config.log.i("initializing firebase...");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Config.log.i("running main() of main.dart, initializing app and going to home page...");
  runApp(PlateWasteApp());
}

