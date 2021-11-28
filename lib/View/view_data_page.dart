import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:plate_waste_recorder/View/view_data_widgets.dart';
import '../Model/variables.dart';
import 'id_input_page.dart';
import 'package:plate_waste_recorder/View/roster_page.dart';

class ViewDataPage extends StatefulWidget {
  //Takes the institution name and address to render a page
  // with options to view the data in different ways
  String institutionName;
  String institutionAddress;
  //Renders the view data menu as an page with the institution name and address
  ViewDataPage(this.institutionName,this.institutionAddress, {Key? key}) : super(key: key);

  @override
  _ViewDataPageState createState() => _ViewDataPageState();
}

class _ViewDataPageState extends State<ViewDataPage> {
  @override
  Widget build(BuildContext context) {

    Config.log.i("building view data page");
    return Scaffold(
        appBar: AppBar(title: Text(
            'View Data For Institution: ${widget.institutionName}')),
        body: Center(
            child: Column(
                children: <Widget>[
                  // add an empty SizedBox between column elements
                  // to create space between elements
                  SizedBox(height: 80.0),
                  ViewDataOption(context, "Scan QR Code", () {
                    //View data for individual student using the QR code
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          setStatusVar("view");
                          return ID_InputPage(); // TODO: replace with actual QR code page
                        }));
                  }),
                  SizedBox(height: 80.0),
                  // add an empty SizedBox between column elements
                  // to create space between elements
                  ViewDataOption(context, "Select From Roster", () {
                    //View data for individual from the roster page
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Roster(); // TODO: replace with roster page
                        }));
                  }),
                  SizedBox(height: 80.0),
                  // add an empty SizedBox between column elements
                  // to create space between elements
                  ViewDataOption(context, "Export Data", () {
                    //View data for individual student using the QR code
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return QRViewExample();
                        }));
                  }),
                ]
            )
        )
    );
  }

}