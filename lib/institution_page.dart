import 'package:flutter/material.dart';

class Institution extends StatefulWidget {
  String institutionName;
  String institutionAddress;

  Institution(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);

  @override
  State<Institution> createState() => _InstitutionState();
}

class _InstitutionState extends State<Institution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("nameOfSchool"), leading: BackButton(), actions: [modifyButton()]),
        body: _InstitutionOptions()
    );
  }

  Widget BackButton(){
    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Icon(Icons.arrow_back)
    );
  }

  Widget modifyButton(){
    return InkWell(
        onTap: () {},
        child: Icon(Icons.edit)
    );
  }
  Widget MenuButton(String btnName){
    return Flexible(
        child: SizedBox(
            height: 100,
            width: 100,
            child: ElevatedButton(
              child: Text(btnName),
              onPressed: () {},

            )
        )
    );
  }

  Widget _InstitutionOptions(){
      return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:  <Widget>[
              const Flexible(
                child: Text("School location and information", style: TextStyle(fontSize: 25))
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MenuButton("QR Code"),
                    MenuButton("Camera"),
                    MenuButton("Roster"),
                  ],

                )
              ),
              Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MenuButton("Record Data"),
                      MenuButton("View Data"),
                      MenuButton("Food"),
                    ],

                  )
              ),
            ],

          )

      );
      }
}
