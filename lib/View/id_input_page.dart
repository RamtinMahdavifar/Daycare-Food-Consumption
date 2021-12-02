import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'id_input_widget.dart';
import 'institution_page_widgets.dart';
import 'qr_scan_id.dart';

class ID_InputPage extends StatefulWidget {
  //Display a option to scan QR code or manually input the id

  ID_InputPage({Key? key}) : super(key: key);

  @override
  State<ID_InputPage> createState() => _ID_InputPageState();
}

class _ID_InputPageState extends State<ID_InputPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    Config.log.i("building id input page");
    return Scaffold(
      appBar: AppBar(
          title: Text("Scan a Student ID"),
          leading: backButton(context),
          actions: [modifyButton()]),
      body: _ID_InputOptions(),
    );
  }

  Widget _ID_InputOptions() {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              child: Text("Scan a Student ID", style: TextStyle(fontSize: 40))),
          Expanded(child: QR_ScanID() //BuildQrView(context)
              ),
          Container(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //most of the buttons do not navigate anywhere and have null as their navigation parameter
                    //menuButton(context,"Input ID", () => InputIDForm(), 1),
                    inputIDButton(context)
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
