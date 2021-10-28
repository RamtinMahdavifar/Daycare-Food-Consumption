import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/View/login_page_widgets.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plate Waste Tracker')),
      body: Center(
        child: ListView(
          children: <Widget>[
            emailField(new TextEditingController()),
            passwordField(new TextEditingController()),
            loginButton(),
            signUpButton(),
            forgotPasswordButton()
          ]
        )
      )
    );
  }
}

