import 'package:flutter/material.dart';
import 'select_institution_widgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'dart:convert'; // required for jsonDecode()



class SelectInstitute extends StatelessWidget {
  const SelectInstitute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Plate Waste Tracker',
        home: ChooseInstitute()
    );
  }
}

class ChooseInstitute extends StatefulWidget {
  @override
  State<ChooseInstitute> createState() => _ChooseInstituteState();
}

class _ChooseInstituteState extends State<ChooseInstitute> {
  @override

/*  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio(); // for http requests

  String _searchText = "";
  List<String>? names; // names we get from API
  List<String>? filteredNames; // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search Example' );*/

/*
  ChooseInstitute() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  initState(){
    this._getNames();
    super.initState();
  }



  void _getNames() {
    */
/*final response = await require("@pipedreamhq/platform").axios(this, {
      url: 'https://swapi.dev/api/films/1/',
    });//await dio.get('https://swapi.co/api/people');*//*


    List<String>? response = ["place", "pl4ce", "jim", 'tim'];

    List<String>? tempList = response;
    response == null ? print("broken") : print("working");
    print(response);
   // for (int i = 0; i < response.length; i++) {
   //   tempList?.add(response[i]);
   // }
    print(tempList);

    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = new Icon(Icons.close);
        _appBarTitle = new TextField(
        //put the visual icon change stuff in the widget page
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'
          )
        );
      } else {
        _searchIcon = new Icon(Icons.search);
        _appBarTitle = new Text('Search Example');
        filteredNames = names;
        _filter.clear();
      }
    });
  }



  Widget _buildList() {
    //final name = filteredNames!.indexOf('name');
    if (!(_searchText.isEmpty)) {
      List<String>? tempList;
      for (int i = 0; i < filteredNames!.length; i++) {
        if (filteredNames![i].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList?.add(filteredNames![i]);
        }
      }
      filteredNames = tempList;
    }
    print(filteredNames);
    return Flexible(
        child: ListView.builder(
          itemCount: names == null ? 0 : filteredNames!.length,
          itemBuilder: (BuildContext context, int index) {
            return new ListTile(
              title: Text(filteredNames![index]),
              onTap: () => print(filteredNames![index]),
            );
          },
        )
    );
  }


  Widget searchInstitution(){
    return Flexible(
      child: Card(
          color: Colors.white60,
          elevation: 2,
          child: ListTile(
              leading: _searchIcon,
              onTap: (){
                  _searchPressed();
              },
              title: const Text("Search Institute")//_appBarTitle
          )
      ),
    );
  }


  Widget quickfixButton(BuildContext context){
    return InkWell(
        onTap: (){
          // pass the name of the clicked on institution to the daycare screen
          _getNames();
        },
        child: Icon(Icons.edit)
    );
  }
*/

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Plate Waste Tracker')),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
                children: [
                  // TODO: move these child widgets to their own files
                  addInstitution(context),
                  searchInstitution(),
                  //_buildList(),
                  institutionDisplay(context),
                  //quickfixButton(context)
                ])
        ),

    );
  }

}