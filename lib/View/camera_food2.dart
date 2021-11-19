import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/View/food_scanned_eaten.dart';
import 'package:plate_waste_recorder/View/id_input_page.dart';
import 'package:plate_waste_recorder/View/login_page.dart';
import 'qrcode.dart';
import "../Model/variables.dart";
//import 'package:camera/camera.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'food_scanned_uneaten.dart';
import 'package:flutter/services.dart';
import 'qr_scan_id.dart';
import 'package:image/image.dart' as i;
import 'dart:io';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';

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


/// used as a shorter way to determine if a value is null or not
bool isNull(String? val){
  // TODO: why can't you just check val==null????
  return val == null ? true : false;
}

class CameraFood2 extends StatefulWidget {
  // this page accepts as a parameter when created, an InstitutionInfo object representing
  // the institution the user is currently adding data for
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  FoodStatus currentFoodStatus;
  CameraFood2(this.currentInstitution, this.currentSubject, this.currentFoodStatus, {Key? key}) : super(key: key);

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
  Directory? directory;





  @override
  void initState() {
    super.initState();
    //this is for the null safety check stuff
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    //set true on first ever launch, false otherwise
    getPath();

    //run this on initial start to create the folder


    //SystemChrome.
  }

  /// locates the external storage location where images will be stored on the
  /// device and then creates an organized file directory for the
  /// institute and the ID if they do not yet exist
  void getPath() async {
    //this could be useful for an issue i was running into with converting a csv to a List
    //use below line to create a directory for the cropped images
    directory = await getExternalStorageDirectory();
    print("EXTERNAL SAVE PATH");
    print(directory);
    String newPath = "";

    List<String> paths = directory!.path.split("/");

    for (int x = 1 ; x < paths.length ; x++){
      String folder = paths[x];
      newPath += "/" + folder;
    }
    if (!isNull(getInst()) && !isNull(getID())){
      newPath = newPath + "/" + getInst()! + "/" + getID()!;
      directory = Directory(newPath);
      print(Text("USING PATH: " + directory!.path));
    }

  }

  /// for each ID, this creates a new directory for every new food item submitted
  /// takes in a String of the name of the new food item that was entered
  Future<int> newPath(String foodname) async{
    Directory newDir;
    String newPath = "";
    List<String> paths = directory!.path.split("/");

    for (int x = 1 ; x < paths.length ; x++){
      String folder = paths[x];
      newPath += "/" + folder;
    }

    if (!isNull(foodname) && directory != null){
      newPath = newPath + "/" + foodname;
      newDir = Directory(newPath);

      if (!await newDir.exists()) {
        await newDir.create(recursive: true);
        print(Text("CREATED PATH: " + newDir.path));
        return 1;
      }
    }
    else{
      print("null foodname");
    }
    return 0;

  }

  /// stores an image to the local device in a specified location set by
  /// getPath() + newPath(), takes an Image that is stored with the name filename
  void savePic(i.Image pic, String fileName) async {
    if (directory != null) {
      if (!await directory!.exists()) {
        await directory!.create(recursive: true);
      }
      if (await directory!.exists()) {
        await newPath(getFoodName()!) == 1
         //make new path
        ? File(directory!.path + "/$fileName").writeAsBytesSync(i.encodePng(pic))

        : print("new path not created");

      }
    }else{
      print("no directory chosen");
    }
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
                      //padding: EdgeInsets.fromLTRB(0.0, 0.0, width!/2 , 0.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 5.0),
                        color: Colors.white
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                              child: BuildQrView(context)
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  idLabel(),
                                  SizedBox(height: height!/5),
                                  captureImageButton(),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      viewDataButton(),
                                      SizedBox(width: 20),
                                      finishButton()
                                    ]
                                  ),
                                  SizedBox(height: 20),
                                ]
                              )
                            )
                          )

                        ],
                      )
                    ) //this is the Viewfinder
                  )
                ),
               ),
            _captureImage(), //camera Capture button
          ]
      ),
    );

  }

  /// button for capturing image
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

    print("image captured Press");
    QRcontroller == null
    ? print("No QR Controller active")
    :
      QRcontroller!.pauseCamera();
      if(widget.currentFoodStatus == FoodStatus.eaten){
        // take a picture of the food on screen, send this to our uneaten food dialog for submission
          await showDialog(
              barrierColor: null,
              barrierDismissible: false,
              context: context,
              builder: (context) => UneatenFoodDialog(QRcontroller!, widget.currentInstitution, widget.currentSubject)
          );//needs to check for null at some point, do this later
        // after returning from our image submission, resume our camera to allow
        // taking pictures for successive meals
        await QRcontroller!.resumeCamera();
      }else if (widget.currentFoodStatus == FoodStatus.eaten || widget.currentFoodStatus == FoodStatus.container){

        await showDialog( //open the dialog first before begining the image capture process
            barrierColor: null,//jank workaround remove the shadow from the dialog
            barrierDismissible: false,
            context: context,
            builder: (_) => foodScannedSecond(context, QRcontroller!) //needs to check for null at some point, do this later
        );
        print("Dialog Code passed");
        print("takeShot completed");
        QRcontroller!.resumeCamera();
        print("Image Capture Finish");

      }else if(getStatus == "preset"){

        print("Adding Preset Container Placeholder");
        await showDialog( //open the dialog first before begining the image capture process
            barrierColor: null,//jank workaround remove the shadow from the dialog
            barrierDismissible: false,
            context: context,
            builder: (_) => LoginPage() //needs to check for null at some point, do this later
        );

        addContainer(getFoodName());

      }

    print("Dialog Code passed");
    print("takeShot completed");
    QRcontroller!.resumeCamera();
    print("Image Capture Finish");
  }

  Widget captureImageButton() {
    return SizedBox(
      height: height!/5,
      width: (width!/3) + 20,
      child: ElevatedButton(

        style: ElevatedButton.styleFrom(
          primary: Colors.white70,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.lightGreen, width: 5),
            borderRadius: new BorderRadius.circular(3)
          ),
        ),
        child: Text(" Capture Image " + " [SPACE]", style: TextStyle(fontSize: 38, color: Colors.black)),
        onPressed:
          SScontroller != null
              ? onTakePictureButtonPressed : null

      )
    );
  }

  Widget viewDataButton() {
    return SizedBox(
      height: height!/6,
      width: width!/6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white70,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 5),
              borderRadius: new BorderRadius.circular(3)
          ),
        ),
        child: Text("View Data", style: TextStyle(fontSize: 32, color: Colors.black)),
        onPressed: () {},
      )
    );
  }

  Widget finishButton() {
    return SizedBox(
      height: height!/6,
      width: width!/6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 5),
              borderRadius: new BorderRadius.circular(3)
          ),
        ),
        child: Text("Finish", style: TextStyle(fontSize: 32)),
        onPressed: () {
          //await reassemble();
          Navigator.of(context, rootNavigator: true).pop(); //leave camera
          Navigator.of(context, rootNavigator: true).pop(); //leave old qr
          Navigator.push(context, MaterialPageRoute( //open new one to scan
              builder: (context) {
                return ID_InputPage(widget.currentInstitution);
              }));


        },
      )
    );
  }

  Widget idLabel() {
    if (!isNull(getID())){
      return Container(child:(Text(getID()!, style: TextStyle(fontSize: 56))));
    }else{
      print("NULL ID USED");
      return Text("INVALID ID");
    }

  }




}

/*
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
 */
// What's this??? This allows a value of typ T or T? to be treated as a val of type T?
// Why?? because this thing is not finished and more stable versions of the flutter camera API
// are not expected to release until late 2021
T? _ambiguate<T>(T? value) => value;