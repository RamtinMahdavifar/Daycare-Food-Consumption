import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';
import 'package:plate_waste_recorder/Model/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFieldController = TextEditingController();
  final TextEditingController _passwordFieldController = TextEditingController();
  // assume our fields are valid by default
  bool _emailFieldValid = true;
  bool _passwordFieldValid = true;

  Widget appIcon(){
    // return an image we get from a local directory, add padding to the top
    // so the image isn't right against the top of the screen, specify padding
    // below so other elements below this aren't too close to the image
    return Padding(padding: EdgeInsets.only(top: 20, bottom: 30),
          child: Image.asset("Icons/apple.png", width: 700, height: 500)
    );
  }

  Widget emailField(){
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          // provide the user with a keyboard specifically for email addresses
          keyboardType: TextInputType.emailAddress,
          controller: this._emailFieldController,
          decoration: InputDecoration(
              hintText: 'Email',
              // if the input provided to this field is invalid, display our error message
              errorText: !this._emailFieldValid ? "Please Enter an Email Address" : null,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0)
              )
          ),
        )
    );
  }

  Widget passwordField(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        // provide the user with a keyboard specifically for inputting passwords
          keyboardType: TextInputType.visiblePassword,
          // hide the characters the user types
          obscureText: true,
          controller: this._passwordFieldController,
          decoration: InputDecoration(
              hintText: 'Password',
              errorText: !this._passwordFieldValid ? "Please Enter a Password" : null,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 5.0)
              )
          )
      ),
    );
  }

  Widget loginButton(){
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
                Config.log.i("user has pressed login button");
                await Authentication().googleSignIn();
                // get the values from each of our input fields
                String inputEmail = this._emailFieldController.value.text;
                // TODO: do something about password here, should we refer to this in plaintext
                String inputPassword = this._emailFieldController.value.text;
                Config.log.i("user attempting to sign in with input email: " + inputEmail);
                // obviously do not log user's password
                // check if each of our fields is valid, do so within a setState
                // call so any changes to these fields is reflected in our other widgets
                setState((){
                  this._emailFieldValid = inputEmail!=null && inputEmail.isNotEmpty;
                  this._passwordFieldValid = inputPassword!=null && inputPassword.isNotEmpty;
                });

                if(this._emailFieldValid && this._passwordFieldValid){
                  // both input fields are valid, login using these fields
                  // TODO: define authentication in separate class, pass these fields to some authentication function
                  // take the user to the select institutions page after successful login
                  // clear our text fields before leaving the page
                  this._emailFieldController.clear();
                  this._passwordFieldController.clear();
                  await Navigator.push(context, MaterialPageRoute(
                      builder: (context){
                        return ChooseInstitute();
                      }));
                }
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

  Widget forgotPasswordButton(){
    // display a button which is only clickable text, no border etc
    return TextButton(
      onPressed: (){
        Config.log.i("pressed forgot password button");
      },
      // specify a slightly smaller font size than regular for this button
      // as we want this button to be more out of the way
      child: const Text("Forgot Password?", style: TextStyle(fontSize: 20.0)),
    );
  }

  Widget signUpButton(){
    // display a button which is only clickable text, no border etc
    return TextButton(
      onPressed: (){
        Config.log.i("pressed sign up button");
      },
      // specify a slightly smaller font size than regular for this button
      // as we want this button to be more out of the way
      child: const Text("Sign Up", style: TextStyle(fontSize: 20.0)),
    );
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

  @override
  void dispose(){
    this._emailFieldController.clear();
    this._passwordFieldController.clear();
    super.dispose();
  }
}

