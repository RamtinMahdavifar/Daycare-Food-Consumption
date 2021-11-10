import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';

import 'qrcode.dart';
//import 'package:camera/camera.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'food_scanned_uneaten.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class CameraFood2 extends StatefulWidget {
  @override
  _CameraFood2State createState() => _CameraFood2State();
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _CameraFood2State extends State<CameraFood2> with
    WidgetsBindingObserver, TickerProviderStateMixin {
  //REMOVE LIKE ALL OF THIS WHEN YOU GET A CHANCE, EXCEPT FOR CAMERA CONTROLLER AND IMAGEFILE

  ScreenshotController? SScontroller;
  QRViewController? QRcontroller;
  Uint8List? imageFile;



  int _pointers = 0;
  @override
  void initState() {
    super.initState();
    //this is for the null safety check stuff
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    //SystemChrome.
  }


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.QRcontroller = controller;
    });

  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
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

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text("Camera Food")),
      body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Center(
                      child: Screenshot(
                          controller: SScontroller!,
                          child: BuildQrView(context) //this is the Viewfinder
                      )

                    )
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        color: Colors.grey,
                        width: 3.0
                    )
                ),
              ),
            ),
            _captureImage(), //camera Capture button
          ]
      ),
    );

  }


  Widget _captureImage() {
    //final CameraController? cameraController = controller;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.green,
            onPressed: SScontroller != null
                ? onTakePictureButtonPressed : null,
          )


        ]
    );
  }
  void showInSnackBar(String message){
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void onTakePictureButtonPressed() {
    //XFile? file = controller.takePicture();
    SScontroller!.capture().then((Uint8List? img) {
      if (mounted) {
        setState(() {
          imageFile = img;
          //removed videoController code as we will not be recording video
          //videoController?.dispose();
          //videoController = null;
        });
        if (img != null){
          showInSnackBar('Picture saved to');

          showDialog(
              context: context,
              builder: (_) => foodScannedFirst(context, img)
          );
        }
      }
    });
  }





}
class FoodCamera2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraFood2(),
    );
  }
}
List<CameraDescription> cameras = [];

Future<void> main() async{
  //assign avaialbe camera
  print("Start");

  runApp(FoodCamera2());
}
// What's this??? This allows a value of typ T or T? to be treated as a val of type T?
// Why?? because this thing is not finished and more stable versions of the flutter camera API
// are not expected to release until late 2021
T? _ambiguate<T>(T? value) => value;