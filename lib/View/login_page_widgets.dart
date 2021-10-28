import 'package:flutter/material.dart';

Widget emailField(TextEditingController emailFieldController){
  return const TextField(
    // provide the user with a keyboard specifically for email addresses
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      hintText: 'Email',
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 5.0)
      )
    ),
  );

}

Widget passwordField(TextEditingController passwordFieldController){
  return const TextField(
    // provide the user with a keyboard specifically for inputting passwords
    keyboardType: TextInputType.visiblePassword,
    // hide the characters the user types
    obscureText: true,
    decoration: InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 5.0)
        )
    ),
  );
}

