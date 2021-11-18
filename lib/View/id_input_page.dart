import 'package:flutter/material.dart';
import 'id_input_widget.dart';
import 'institution_page_widgets.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import '../Model/variables.dart';
import 'camera_food2.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class ID_InputPage extends StatefulWidget {


  ID_InputPage( {Key? key}) : super(key: key);

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

  Widget BuildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0

        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async{
    setState(() {
      this.controller = controller;
      if (this.controller != null) {
        this.controller!.flipCamera();
      } else {
        print("null controller used");
      }
    });


    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        setIDVar(result!.code);
      });

      controller.stopCamera();

      Navigator.push(context, MaterialPageRoute(
          builder: (context){
            //reassemble();
            return CameraFood2();
            // on qr found, take to food data input screen, this will be
            // modified to account for viewing id data and the two different
            // food data input screens
          }));

    });
  }


  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    Config.log.i('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
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
                  return InputIDForm();
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
                child: BuildQrView(context)
              ),
              Container(
                child: Padding(padding: EdgeInsets.all(10),
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
          )
      ),);
  }
}


