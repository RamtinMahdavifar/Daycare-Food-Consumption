import 'package:flutter/material.dart';

class ViewDataPage extends StatefulWidget {
  String institutionName;
  String institutionAddress;

  ViewDataPage(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);


  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View Data For Institution: ${widget.institutionName}')),
      body: Center(
          child: Column(
              children: <Widget>[
                SizedBox(height: 80.0),
                Card(
                  // TODO: make sizes relative to screen size
                    child: SizedBox(width: 800.0, height: 80.0,
                        child: Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 40.0, right: 40.0),
                            child: ListTile(title: Center(child: Text("test 1"))))
                    )
                ),
                SizedBox(height: 80.0), // add an empty SizedBox between column elements
                // to create space between elements
                Card(
                    child: SizedBox(width: 800.0, height: 80.0,
                        child: Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 40.0, right: 40.0),
                            child: ListTile(
                                title: Center(child: Text("test 2"))),
                        )
                    )
                ),
                SizedBox(height: 80.0),
                Card(
                    child: SizedBox(width: 800.0, height: 80.0,
                        child: Container(margin: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 40.0, right: 40.0),
                            child: ListTile(title: Center(child: Text("test 3"))))
                    )
                )
              ]
          )
      )
    );
  }
}
