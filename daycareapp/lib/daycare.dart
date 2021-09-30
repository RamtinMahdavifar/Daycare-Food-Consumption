
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
      appBar: AppBar(title: Text("nameOfSchool"), leading: BackButton()),
        body: _DaycareMenu()
    );
  }

  Widget BackButton(){
    return InkWell(
      onTap: () => runApp(SelectInstitute()),
      child: Icon(Icons.arrow_back)
    );
  }

  Widget _DaycareMenu(){
      return const Scaffold(
          body: Text("School location and information"),
      );
      }
}
