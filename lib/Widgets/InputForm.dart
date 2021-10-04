// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final textController = TextEditingController();
  int keyNumber = 0;

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Input your text...")
      ),
      body: TextField(
          controller: this.textController
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Submit your text...",
        onPressed: ()=>submitForm(context),
      )
    );
  }

  void submitForm(BuildContext context){
    String inputText = this.textController.text;
    databaseReference.child(this.keyNumber.toString()).set({
      "text": inputText
    });
    this.keyNumber++;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(inputText),
          );
        });
    this.textController.clear();
    databaseReference.once().then((dataSnapshot) => (print(dataSnapshot.value.toString())));

  }
}
