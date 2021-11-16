import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';
import 'package:plate_waste_recorder/Model/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // keep track of whether the user has clicked and is waiting for a google account
  // popup to sign in, if so display a loading graphic
  bool _authenticationLoading = false;

  Widget appIcon(){
    // return an image we get from a local directory, add padding to the top
    // so the image isn't right against the top of the screen, specify padding
    // below so other elements below this aren't too close to the image
    return Padding(padding: EdgeInsets.only(top: 20, bottom: 30),
          child: Image.asset("Icons/apple.png", width: 700, height: 500)
    );
  }

  Widget loginButton(){
    if(this._authenticationLoading){
      // authentication is currently loading, display a loading animation
      Config.log.i("waiting for google authentication to complete");
      return Center(child: CircularProgressIndicator(
        value: null,
        color: Colors.green,
      ));
    }
    else{
      return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
              height: 70,
              child: ElevatedButton(
                // this particular button will be a "Sign in with Google" button
                // as such additional restrictions apply, see https://developers.google.com/identity/branding-guidelines?hl=en
                // for details, buttons must be pure white ie #FFFFFF
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      // specify rounded edges for the button, add a blue border to make the button
                      // more distinct from the background
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                      side: MaterialStateProperty.all(BorderSide(width: 1, color: Colors.blue))
                  ),
                  onPressed: () async {
                    Config.log.i("user has pressed login button, attempting to login via google");
                    await Authentication().googleSignOut();
                    // the user has pressed the login button, change the state to reflect that
                    // the app is waiting for the google authentication popup
                    setState((){
                      this._authenticationLoading = true;
                    });
                    // attempt to login to the app via google
                    await Authentication().googleSignIn().then((result){
                      // we have finished authenticating without errors
                      Config.log.i("Authentication finished successfully, navigating to home page...");
                      setState((){
                        this._authenticationLoading = false;
                      });

                      // we've logged in without errors, go to the ChooseInstitute page
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return ChooseInstitute();
                          }));
                    }).catchError((error){
                      // we must use catchError to deal with any exceptions thrown by this sign in function
                      // as exceptions can be thrown asynchronously or are not caught
                      // by regular try-catches, this is an ongoing flutter bug, see: https://github.com/flutter/flutter/issues/44431
                      Config.log.e("Error occurred during login, error: ${error.toString()}");
                      // authentication has finished due to error occurrence
                      setState((){
                        this._authenticationLoading = false;
                      });

                      // display to the user that an error has occurred during login
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                        const Text("Login failed, please try again")
                      ));
                    });
                  },
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // specify padding for each element of this button as we need our "Sign in with Google"
                        // text to be to the right of the google logo, specify a grey font colour for the text or
                        // else it doesn't show up against the white background of the button
                        Padding(padding: EdgeInsets.only(left:0), child: Image.asset("Icons/google-logo-button.png")),
                        Padding(padding: EdgeInsets.only(left: 10), child: Text("Sign in with Google", style: TextStyle(color: Colors.black54, fontSize: 28.0)))
                      ]
                  )
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plate Waste Tracker')),
      body: Center(
        child: ListView(
          children: <Widget>[
            appIcon(),
            loginButton()
          ]
        )
      )
    );
  }
}

