import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/View/id_input_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:screenshot/screenshot.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';

import 'dart:developer';

import 'food_input_dialog.dart';



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

class FoodCapture extends StatefulWidget {
  // this page accepts as a parameter when created, an InstitutionInfo object representing
  // the institution the user is currently adding data for
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  FoodStatus currentFoodStatus;
  FoodCapture(this.currentInstitution, this.currentSubject, this.currentFoodStatus, {Key? key}) : super(key: key);

  @override
  _FoodCaptureState createState() => _FoodCaptureState();
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _FoodCaptureState extends State<FoodCapture> with
    WidgetsBindingObserver, TickerProviderStateMixin {
  ScreenshotController SScontroller = ScreenshotController();
  QRViewController? QRcontroller;
  double? width;
  double? height;

  @override initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

  }


  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// when the viewfinder is opened, assign the controller and flip the camera
  /// to use either the rear facing or the external camera by default
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.QRcontroller = controller;
    });

    this.QRcontroller!.flipCamera(); //default use the external camera

  }


  /// permission handler for when you first want to use the camera
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  /// creates the qr reader
  Widget BuildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    width == null ? width = 480 : null; //if a width dimension not returned
    // display a different title for this page depending on the type or status of
    // the food items being entered
    String pageTitle = "";
    switch (widget.currentFoodStatus){
      case FoodStatus.uneaten:
        pageTitle = "Capture Uneaten Food Item";
        break;
      case FoodStatus.eaten:
        pageTitle = "Capture Eaten Food Item";
        break;
      case FoodStatus.container:
        pageTitle = "Capture Food Container";
        break;
      default:
        pageTitle = "Capture Food Item";
        break;
    }
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(pageTitle), automaticallyImplyLeading: false),
      body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                    child: Container(
                      //padding: EdgeInsets.fromLTRB(0.0, 0.0, width!/2 , 0.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blueAccent, width: 5.0),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(child: BuildQrView(context)),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Center(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                    idLabel(),
                                    SizedBox(height: height! / 5),
                                    captureImageButton(),
                                    SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          viewDataButton(),
                                          SizedBox(width: 20),
                                          finishButton()
                                        ]),
                                    SizedBox(height: 20),
                                  ])))
                        ],
                      )) //this is the Viewfinder
                  )),
        ),
        _captureImage(), //camera Capture button
      ]),
    );
  }

  /// repurposed capture image now used as a spacer
  Widget _captureImage() {
    //final CameraController? cameraController = controller;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.white,
            onPressed: () {},
          )
        ]);
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  /// handles what happens when the image capture button is pressed, not only is
  /// the image captured, but depending on the FoodStatus, it will pull up
  /// different data submission dialogs for food eaten or uneaten/container
  /// and if the status is "preset" rather than saving the image to local storage
  /// it creates a new container preset.
  ///
  /// due to the long delay when screenshotting, cropping and then saving the
  /// image, with a bit of illusion tricks, the viewfinder is paused to show the
  /// user what the image will look like after its been cropped and saved, the
  /// image will be backwards however
  void onTakePictureButtonPressed() async {

    QRcontroller == null
        ? Config.log.i("No QR Controller active")
        : QRcontroller!.pauseCamera();
    if(widget.currentFoodStatus == FoodStatus.uneaten || widget.currentFoodStatus == FoodStatus.eaten || widget.currentFoodStatus == FoodStatus.container){
    // take a picture of the food on screen, send this to our uneaten food dialog for submission
    await showDialog(
    barrierColor: null,
    barrierDismissible: false,
    context: context,
    builder: (_) => FoodInputDialog(widget.currentInstitution, widget.currentSubject, widget.currentFoodStatus)
    );//needs to check for null at some point, do this later
    }
    //takeShot();
    QRcontroller!.resumeCamera();
    Config.log.i("Image Capture Finish");
  }

  Widget captureImageButton() {
    return SizedBox(
        height: height! / 5,
        width: (width! / 3) + 20,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.white70,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.lightGreen, width: 5),
                  borderRadius: new BorderRadius.circular(3)),
            ),
            child: Icon(Icons.camera_alt, color: Colors.green, size: 75),
                //style: TextStyle(fontSize: 38, color: Colors.black)),
            onPressed:
                SScontroller != null ? onTakePictureButtonPressed : null));
  }

  Widget viewDataButton() {
    return SizedBox(
        height: height! / 6,
        width: width! / 6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white70,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 5),
                borderRadius: new BorderRadius.circular(3)),
          ),
          child: Text("View Data",
              style: TextStyle(fontSize: 32, color: Colors.black)),
          onPressed: () {},
        ));
  }

  Widget finishButton() {
    return SizedBox(
        height: height! / 6,
        width: width! / 6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 5),
                borderRadius: new BorderRadius.circular(3)),
          ),
          child: Text("Finish", style: TextStyle(fontSize: 32)),
          onPressed: () {
            //await reassemble();
            Navigator.of(context, rootNavigator: true).pop(); //leave camera
            Navigator.of(context, rootNavigator: true).pop(); //leave old qr
            Navigator.push(context, MaterialPageRoute(//open new one to scan
                builder: (context) {
              return ID_InputPage(widget.currentInstitution, widget.currentFoodStatus);
            }));
          },
        ));
  }

  Widget idLabel() {

    String currentSubjectID = widget.currentSubject.subjectId;
    assert(currentSubjectID.isNotEmpty);
    return Container(child:(Text(currentSubjectID, style: TextStyle(fontSize: 56))));
  }
}
// What's this??? This allows a value of typ T or T? to be treated as a val of type T?
// Why?? because this thing is not finished and more stable versions of the flutter camera API
// are not expected to release until late 2021

T? _ambiguate<T>(T? value) => value;


