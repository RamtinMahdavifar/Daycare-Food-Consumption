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
  @override
  void initState() {
    FoodBank.getFoodNames();
    print("food bank names added!");
    employeeData  = List<List<dynamic>>.empty(growable: true);
    super.initState();
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String? _selectedCity;

  late List<List<dynamic>> employeeData;
  final String root =  getApplicationDocumentsDirectory().toString();



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  String? _extension="csv";
  FileType _pickingType = FileType.custom;

   openFile(String filepath) async
  {
    File f = new File(filepath);
    print("CSV to List");
    print(root);
    final input = f.openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    print(fields);
    setState(() {
      employeeData=fields;
    });
  }

  void _openFileExplorer() async {

    try {

      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path.toString());
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);

    });
  }

  void _uploadFood() async{
     setState(() {
       openFile("food_names.csv");
       print(employeeData);
     });
  }



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plate Waste Tracker')),
      body: Container(margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
              children: [
                // TODO: move these child widgets to their own files
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
                        return 'Please select a city';
                      }
                    },
                    onSaved: (value) => _selectedCity = value,
                  ),
                  SizedBox(height: 10.0,),
                  RaisedButton(
                    child: Text('Submit'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Your Favorite City is ${_selectedCity}')
                        ));
                      }
                    },
                  ),
                  Container(
                    child: Container(
                      color: Colors.green,
                      height: 30,
                      child: TextButton(
                        child: Text("CSV To List",style: TextStyle(color: Colors.white),),
                        onPressed: _uploadFood,//_openFileExplorer,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
              ])
      ),

    );
  }

}

