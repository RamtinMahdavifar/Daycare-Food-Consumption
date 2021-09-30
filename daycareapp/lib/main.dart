import 'package:flutter/material.dart';
import 'daycare.dart';

void main() {
  runApp(
    const SelectInstitute(),
  );
}

class SelectInstitute extends StatelessWidget {
  const SelectInstitute({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daycare',
      home: ChooseInstitute()
    );
  }
}

class ChooseInstitute extends StatefulWidget {
  @override
  State<ChooseInstitute> createState() => _ChooseInstituteState();
}

class _ChooseInstituteState extends State<ChooseInstitute> {

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daycare Food Project')),
      body: _mainMenu(),
    );
  }

  Widget listedInst(String name){
    return Card(
        child: ListTile(
            onTap: (){
              runApp(Daycare());
            },
            leading: const Icon(Icons.flight_land_rounded),
            title: Text(name)
        )
    );
  }

  Widget formEntry(String labelName){
    return TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty){
            return 'missing fields';
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: labelName
        )
    );
  }

  Widget formSubmit(){
    return ElevatedButton(
        onPressed: (){
          Navigator.of(context, rootNavigator: true).pop();
          if(_formKey.currentState!.validate()){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Submited")),
            );
          }

        },
        child: const Text("Submit")
    );
  }

  Widget enterSchoolForm(){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 3,
      child: Form(
          child: Column(
              children: <Widget>[
                formEntry("name"),
                formEntry("location"),
                formEntry("other information"),
                formSubmit()
              ]
          )

      ),
    );
  }

  Widget addInstitute(){
    return InkWell(
      onTap: (){
        showDialog(
            context: context,
            builder: (context) {
              return enterSchoolForm();
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
                        child: Text("Add Institute", style: TextStyle(fontSize: 25, color: Colors.white))
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

  Widget _mainMenu(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(

        children: [
          addInstitute(),
          searchInstitution(),
          Flexible(
            fit: FlexFit.loose,
            child: ListView(
                children: <Widget> [
                  listedInst("First School"),
                  listedInst("Second School"),
                  listedInst("Third School"),
                  listedInst("Fourth School"),
                  listedInst("Fifth School"),
                  listedInst("Sixth School"),
                  listedInst("Seventh School"),
                  listedInst("Eighth School"),
                  listedInst("Ninth School"),
                  listedInst("Tenth School"),
                ]
            ),
          )
        ],
      )
    );
  }
}
