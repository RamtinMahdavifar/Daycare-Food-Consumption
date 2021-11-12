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

    this.QRcontroller!.flipCamera();



  }

  void takeShot() async {


    String? path = await FlutterNativeScreenshot.takeScreenshot();
    Directory appPath = await getApplicationDocumentsDirectory();
    //this could be useful for an issue i was running into with converting a csv to a List
    //use below line to create a directory for the cropped images
/*    new Directory(appPath.path+'/'+'croppedOut').create(recursive: true)
// The created directory is returned as a Future.
        .then((Directory directory) {
      print('Path of New Dir: '+directory.path);
    });*/
    print("takeShot: Path!");
    print(path);
    int testNo = 013; //this makes unique images since they dont overwrite
    String imgAppend = testNo.toString() + ".png";
    imgFile = File(path!); //image created from og screenshot
    i.Image IMG = i.decodePng(File(path).readAsBytesSync())!; //encode the og image into IMG

    width != null && height != null
      ? IMG = i.copyCrop(IMG, 5, 100, (width! - 845).toInt(), (height! - 200).toInt())
      : IMG = i.copyCrop(IMG, 400, 100, 500, 500); //resize OG image to be smaller
    File(appPath.path+"/croppedOut/" + imgAppend).writeAsBytesSync(i.encodePng(IMG)); //save new image in new location
    String imgPath = appPath.path + "/croppedOut/" + imgAppend; //location path called imgPath
    showDialog(
        context: context,
        builder: (_) => foodScannedFirst(context, File(imgPath)) //needs to check for null at some point, do this later
    );




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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text("Camera Food")),
      body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 800.0, 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 5.0),
                        color: Colors.amberAccent
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

  void onTakePictureButtonPressed() {
    print("image captured Press");
    //XFile? file = controller.takePicture();
    QRcontroller!.pauseCamera();
    takeShot();
    QRcontroller!.resumeCamera();

    print("Image Capture In Progress");
    //print(imgFile!.path);
    /*showDialog(
        context: context,
        builder: (_) => foodScannedFirst(context, imgFile!) //needs to check for null at some point, do this later
    );*/

    /*SScontroller!.capture().then((Uint8List? img){

      setState(() {
        imageFile = img;
      });

      takeShot();
      print("Image Capture In Progress");
      print(imgFile!.path);
      showDialog(
          context: context,
          builder: (_) => foodScannedFirst(context, imgFile) //needs to check for null at some point, do this later
      );
    });*/
    //QRcontroller!.resumeCamera();
    print("Image Capture Finish");
  }




  Future<dynamic> ShowCapturedWidget(BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) =>
          Scaffold(
            appBar: AppBar(
              title: Text("Captured widget screenshot"),
            ),
            body: Center(
                child: capturedImage != null
                    ? Image.memory(capturedImage)
                    : Container(child: Text("fuck"))),
          ),
    );
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