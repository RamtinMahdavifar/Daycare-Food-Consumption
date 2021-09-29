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
      appBar: AppBar(
        title: Text("Menu"),
      ),
    );
  }

  Widget _DaycareMenu(){
      return Container(
          child: Card(
            child:InkWell(

              onTap: () {},
              child: const Icon(Icons.arrow_back)

            )
          )
        );
      }
}
