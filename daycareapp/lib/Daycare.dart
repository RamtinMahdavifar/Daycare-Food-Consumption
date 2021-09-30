import 'package:daycareapp/main.dart';
import 'package:flutter/material.dart';

void main() {
    runApp(
      Daycare()
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
      appBar: AppBar(title: Text("Menu"),),
        body: _DaycareMenu()
    );
  }

  Widget _DaycareMenu(){
      return Container(
          child: Card(
            child:InkWell(

              onTap: () {runApp(SelectInstitute());},
              child: const Icon(Icons.arrow_back)

            )
          )
        );
      }
}
