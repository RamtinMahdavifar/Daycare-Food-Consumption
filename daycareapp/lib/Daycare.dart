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
      home: Scaffold(
        appBar: AppBar(
          title: Text("daycare Menu"),
        ),
      )
    );
  }
}