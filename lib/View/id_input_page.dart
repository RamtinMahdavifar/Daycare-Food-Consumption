import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'id_input_widget.dart';
import 'institution_page_widgets.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import '../Model/variables.dart';
import 'camera_food2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'qr_scan_id.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';


class ID_InputPage extends StatefulWidget { // TODO: why is there an _ in this name

  InstitutionInfo currentInstitution;
  FoodStatus currentFoodStatus;
  ID_InputPage(this.currentInstitution, this.currentFoodStatus, {Key? key}) : super(key: key);


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
      appBar: AppBar(title: Text("Scan a Student ID"), leading: backButton(context), actions: [modifyButton()]),
      body: _ID_InputOptions(),
    );
  }


  Widget inputIDButton(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        height: height/12,
        width: width/2,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 5),
                borderRadius: new BorderRadius.circular(3)
            ),
          ),
          child: Text("Manual ID Entry", style: TextStyle(fontSize: 32)),
          onPressed: () {
            //await reassemble();
            Navigator.push(context, MaterialPageRoute( //open new one to scan
                builder: (context) {
                  return InputIDForm(widget.currentInstitution, widget.currentFoodStatus);
                }));


          },
        )
    );
  }

  Widget _ID_InputOptions(){
    return SafeArea(
      child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:  <Widget>[
              Container(
                  child: Text("Scan a Student ID", style: TextStyle(fontSize: 40))
              ),
              Expanded(
                child: QR_ScanID(widget.currentInstitution, widget.currentFoodStatus)//BuildQrView(context)
              ),
              Container(
                child: Padding(padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        inputIDButton(context)
                      ],
                    )),
              ),
            ],
          )
      ),);
  }
}


