import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'qrcode.dart';
//import 'package:camera/camera.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'food_scanned_uneaten.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import "package:flutter_native_screenshot/flutter_native_screenshot.dart";
import 'package:image/image.dart' as i;

/*

  the way this camera works for the chrome books since flutter camera API does
  not support using external cameras, is by using the viewfinder from the QR
  scanner and screenshotting the whole screen, and the cropping the image to
  only show the food. this however is very slow, so, were actually gonna pause
  the viewfinder, and popup the dialog next to the now paused viewfinder, then
  user can submit written data right away, while the image is being made and
  cropped, if user wants to retake image, then that image will be deleted
  and the viewfinder is resumed.

 */

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

  ScreenshotController SScontroller = ScreenshotController();
  QRViewController? QRcontroller;
  Uint8List? imageFile;
  File? imgFile;
  double? width;
  double? height;
  Directory? appPath;


  @override
  void initState() {
    super.initState();
    //this is for the null safety check stuff
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    getPath();

    //SystemChrome.
  }

  void getPath() async {
    appPath = await getApplicationDocumentsDirectory();
  }


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.QRcontroller = controller;
    });

    this.QRcontroller!.flipCamera(); //default use the external camera



  }

  void takeShot() async {


    String? path = await FlutterNativeScreenshot.takeScreenshot();

    //this could be useful for an issue i was running into with converting a csv to a List
    //use below line to create a directory for the cropped images
/*    new Directory(appPath.path+'/'+'croppedOut').create(recursive: true)
// The created directory is returned as a Future.
        .then((Directory directory) {
      print('Path of New Dir: '+directory.path);
    });*/
    print("takeShot: Path!");
    print(path);
    int testNo = 014; //this makes unique images since they dont overwrite
    String imgAppend = testNo.toString() + ".png";
    imgFile = File(path!); //image created from og screenshot
    i.Image IMG = i.decodePng(File(path).readAsBytesSync())!; //encode the og image into IMG

    width != null && height != null
      ? IMG = i.copyCrop(IMG, 5, 100, (width! - 845).toInt(), (height! - 200).toInt())
      : IMG = i.copyCrop(IMG, 400, 100, 500, 500); //resize OG image to be smaller
    if (appPath != null){
      String imgPath = appPath!.path + "/croppedOut/" + imgAppend; //location path called imgPath
      File(imgPath).writeAsBytesSync(i.encodePng(IMG)); //save new image in new location
    }else{
      print("No photoFile folder found!");
      return;
    }


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
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    width == null ? width = 480 : null; //if a width dimension not returned
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text("Camera Food")),
      body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, width!/2 , 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 5.0),
                        color: Colors.white
                      ),
                      child: BuildQrView(context)
                    ) //this is the Viewfinder
                  )
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

  void onTakePictureButtonPressed() async {
    print("image captured Press");
    //XFile? file = controller.takePicture();
    QRcontroller!.pauseCamera();
    QRcontroller == null
    ? print("No QR Controller active")
    : await showDialog( //open the dialog first before begining the image capture process
        barrierColor: null,//jank workaround remove the shadow from the dialog
        barrierDismissible: false,
        context: context,
        builder: (_) => foodScannedFirst(context, QRcontroller!) //needs to check for null at some point, do this later
    );
    print("Dialog Code passed");
    takeShot();
    print("takeShot completed");
    QRcontroller!.resumeCamera();
    print("Image Capture Finish");
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