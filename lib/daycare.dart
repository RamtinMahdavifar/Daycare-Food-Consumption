


import 'main.dart';
import 'package:flutter/material.dart';

class Daycare extends StatelessWidget {
  String institutionName;
  String institutionAddress;

  Daycare(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO remove this class, could go right into DaycareMenu
    return Scaffold(
      body: DaycareMenu(),
    );
  }
}

class DaycareMenu extends StatefulWidget {
  @override
  State<DaycareMenu> createState() => _DaycareMenuState();
}

class _DaycareMenuState extends State<DaycareMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("nameOfSchool"), leading: BackButton(), actions: [modifyButton()]),
        body: _DaycareMenu()
    );
  }

  Widget BackButton(){
    return InkWell(
      onTap: (){
        Navigator.pop(context);
      },/*Navigator.push(context, MaterialPageRoute(
          builder: (context){
            return SelectInstitute();
          })),*/
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

  Widget _DaycareMenu(){
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
