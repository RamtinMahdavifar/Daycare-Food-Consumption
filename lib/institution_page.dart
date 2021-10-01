import 'package:flutter/material.dart';

class InstitutionPage extends StatefulWidget {
  String institutionName;
  String institutionAddress;

  InstitutionPage(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);

  @override
  State<InstitutionPage> createState() => _InstitutionPageState();
}

class _InstitutionPageState extends State<InstitutionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.institutionName.toString()), leading: BackButton(), actions: [modifyButton()]),
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
              Flexible(
                child: Text("Address: " + widget.institutionAddress, style: TextStyle(fontSize: 25))
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
