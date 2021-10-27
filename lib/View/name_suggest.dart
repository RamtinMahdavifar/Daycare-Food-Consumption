import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Model/food.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';


class NameSuggest extends StatelessWidget {
  const NameSuggest({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Search Foods',
        home: ChooseFood()
    );
  }
}

class ChooseFood extends StatefulWidget {
  @override
  State<ChooseFood> createState() => _ChooseFoodState();
}

class _ChooseFoodState extends State<ChooseFood> {
  @override


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String? _selectedFood;


  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plate Waste Tracker')),
      body: Container(margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
              children: [
            Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  Text(
                      'Enter Food Name'
                  ),
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _typeAheadController,
                        decoration: InputDecoration(
                            labelText: 'FoodName'
                        )
                    ),
                    suggestionsCallback: (pattern) {
                      return FoodBank.getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion.toString()),
                      );
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (suggestion) {
                      _typeAheadController.text = suggestion.toString();
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a food';
                      }
                    },
                    onSaved: (value) => _selectedFood = value,
                  ),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('You selected ${_selectedFood}')
                        ));
                      }
                    },
                  ),
                ],
              ),
            ),
          )
              ])
      ),

    );
  }

}

