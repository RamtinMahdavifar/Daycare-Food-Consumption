


import 'main.dart';
import 'package:flutter/material.dart';

void main() {
    runApp(
      const Daycare()
  );
}

class Daycare extends StatelessWidget {
  const Daycare({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Daycare Menu",
      home: DaycareMenu()
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
      appBar: AppBar(title: const Text("nameOfSchool"), leading: BackButton()),
        body: _DaycareMenu()
    );
  }

  Widget BackButton(){
    return InkWell(
      onTap: () => runApp(SelectInstitute()),
      child: Icon(Icons.arrow_back)
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

          ),

      );
      }
}
