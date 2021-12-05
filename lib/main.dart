import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/login_page.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';

class PlateWasteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.log.i("building app...");
    Widget homePage;
    if(kDebugMode){
      // the app is being run in debug mode, send the user directly to the institutions
      // select page instead of taking the user to the login page for ease of testing
      Config.log.i("app is running in debug mode, using the institutions select page as a home page");
      homePage = ChooseInstitute();
    }
    else{
      // the app is not running in debug mode, take the user to the login page
      // as the default home page
      Config.log.i("app is not running in debug mode, using the login page as a home page");
      homePage = LoginPage();
    }
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
        home: homePage,
    );
  }
}


void main() async{
  Config.log.i("initializing firebase...");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Config.log.i("enabling firebase offline data caching...");
  // this setting ensures that firebase will cache any data read from our database locally
  // firebase will cache up to 10 MB, the user must of course have read in data previously
  // to have it cached, if the user loses their connection to firebase, they will read
  // and write data locally, this data will be synchronized when the user connects
  // to firebase again
  await FirebaseDatabase.instance.setPersistenceEnabled(true);
  Config.log.i("running main() of main.dart, initializing app and going to home page...");
  runApp(PlateWasteApp());
}

