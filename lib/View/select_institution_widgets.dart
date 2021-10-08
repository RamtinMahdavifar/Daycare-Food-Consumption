import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/View/upload_data.dart';
import '../Model/institution.dart';
import 'institution_page.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:firebase_database/firebase_database.dart'; // need to include for the Event data type
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'dart:convert'; // required for jsonDecode()

final _newInstitutionNameController = TextEditingController();
final _newInstitutionAddressController = TextEditingController();
final _formKey = GlobalKey<FormState>();


//select_institution page button which navigates to that desired institution_page
Widget listedInst(BuildContext context, String name, String address){
  return Card(
      child: ListTile(
          onTap: (){
            // pass the name of the clicked on institution to the daycare screen
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  return InstitutionPage(name, address);
                }));
          },
          leading: const Icon(Icons.flight_land_rounded),
          title: Text(name)
      )
  );
}


//
Widget formEntry(String labelName, Icon icon, TextEditingController controller){
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty){
        return 'missing fields';
      }
      return null;
    },
    decoration: InputDecoration(
        icon: icon,
        labelText: labelName
    ),
    controller: controller,
  );
}

Widget formSubmit(BuildContext context){
  return ElevatedButton(
      onPressed: (){
        /*
          this code causes a crash, formkey.currentState is null
          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Submitted")),
            );
          }
           */
        // TODO: display this snackbar, add input validation etc
        const SnackBar(content: Text("Submitted"));
        String newName = _newInstitutionNameController.value.text;
        String newAddress = _newInstitutionAddressController.value.text;
        Database().addInstitutionToResearchGroup(Institution(newName, newAddress), ResearchGroupInfo("testResearchGroupName"));

        // clear our text fields before exiting the add Institution popup
        _newInstitutionNameController.clear();
        _newInstitutionAddressController.clear();
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: const Text("Submit")
  );
}

Widget formCancel(BuildContext context){
  return ElevatedButton(
      onPressed: (){
        // clear the text fields before exiting the add Institution popup
        _newInstitutionNameController.clear();
        _newInstitutionAddressController.clear();
        Navigator.of(context, rootNavigator: true).pop();
      },
      child: const Text("Cancel")
  );
}

//dialog popup to enter a new school into database
Widget enterSchoolForm(BuildContext context){
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    elevation: 3,
    child: Form(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              formEntry("name", const Icon(Icons.home), _newInstitutionNameController),
              formEntry("address", const Icon(Icons.location_on_outlined), _newInstitutionAddressController),
              //formEntry("other information", Icon(Icons.info_outline)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [formCancel(context), formSubmit(context)],
              )
            ]
        )

    ),
  );
}

//simple button, on press opens the dialog to add info for new inst.
Widget addInstitution(BuildContext context){
  return InkWell(
    onTap: (){
      showDialog(
          context: context,
          builder: (context) {
            return enterSchoolForm(context);
          }
      );
    }, //pop up form entry window
    child: Card(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
        ),
        color: Colors.green,
        elevation: 2,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      height: 55,
                      width: 30,
                      child: const Icon(
                          Icons.add,
                          color: Colors.white)
                  )
              ),
              const Expanded(
                  flex: 3,
                  child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Add Institution", style: TextStyle(fontSize: 25, color: Colors.white))
                  )
              )
            ]
        )
    ),
  );
}

Widget searchInstitution(){
  return const Flexible(
    child: Card(
        color: Colors.white60,
        elevation: 2,
        child: ListTile(
            leading: Icon(Icons.search),
            title: Text("Search Institutions"))),
  );
}

Widget institutionDisplay(BuildContext context) {
  return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder<Event>(
        // use the ResearchGroup with name testResearchGroupName as a sort of stub
        // as we don't yet have adding/joining research groups implemented
        // TODO: get current ResearchGroup user is in and display it's info here
          stream: Database().getResearchGroupStream(
              ResearchGroupInfo("testResearchGroupName")),
          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              children = <Widget>[Text("errors in database read occured")];
            }
            else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children = <Widget>[Text("connection state none")];
                  // TODO: include a network error message or read local data
                  break;
                case ConnectionState.waiting:
                  children = <Widget>[Text("connection state waiting")];
                  // TODO: include a loading or progress bar
                  break;
                case ConnectionState.active:
                // TODO: see about using async database function to return a ResearchGroup to do all this
                // TODO: instead of having to have the below code to create a ResearchGroup here
                  DataSnapshot researchGroupSnapshot = snapshot.data!.snapshot;
                  Map<dynamic, dynamic> testMap = researchGroupSnapshot.value;
                  String encodedMap = jsonEncode(testMap);

                  Map<String, dynamic> researchGroupJSON = json.decode(
                      encodedMap
                  );
                  ResearchGroup retrievedResearchGroup = ResearchGroup.fromJSON(
                      researchGroupJSON);
                  children = retrievedResearchGroup.institutionsMap.values.map(
                          (institution) =>
                          listedInst(context, institution.name,
                              institution.institutionAddress)
                  ).toList();
                  break;
                case ConnectionState.done:
                  children = <Widget>[Text("connection state done")];
                  break;
              }
            }
            return ListView(
                children: children
            );
          })
  );
}

//used if the database breaks, a bandaid solution to allow me to go to any screen nessessary
Widget quickfixButton(BuildContext context){
  return InkWell(
      onTap: (){
        // pass the name of the clicked on institution to the daycare screen
        Navigator.push(context, MaterialPageRoute(
            builder: (context){
              return UploadData();
            }));
      },
      child: Icon(Icons.edit)
  );
}