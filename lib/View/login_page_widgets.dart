import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

Widget emailField(TextEditingController emailFieldController){
  return const Padding(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        // provide the user with a keyboard specifically for email addresses
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 5.0)
          )
        ),
      )
  );
}

Widget passwordField(TextEditingController passwordFieldController){
  return const Padding(
    padding: EdgeInsets.all(10.0),
    child: TextField(
    // provide the user with a keyboard specifically for inputting passwords
    keyboardType: TextInputType.visiblePassword,
    // hide the characters the user types
    obscureText: true,
    decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
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
        height: 50,
        child:
          ElevatedButton(
            onPressed: (){
            Config.log.i("pressed login button");
            },
            child: const Text("Login"),
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

