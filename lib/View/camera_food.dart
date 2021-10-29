import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import 'package:video_player/video_player.dart';


class CameraFood extends StatefulWidget {
  @override
  _CameraFoodState createState() => _CameraFoodState();
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _CameraFoodState extends State<CameraFood> with
    WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  //VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;


  int _pointers = 0;
  @override
  void initState() {
    super.initState();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    /*_flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );*/


    /*_flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );*/


    /*_exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );*/


    /*_exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );*/


   /* _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );*/


    /*_focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );*/


  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  child: _cameraPreviewWidget()
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
          _captureControlRowWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _cameraToggleRowWidget()
                ],
            )
          )
        ]
      ),
    );

  }

  void showInSnackBar(String message){
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }


  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Text(
        'Tap a camera\n${cameraController==null}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  //onTapDown: (details) => onViewFinderTap(details, constraints),
                );
              }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details){
    _baseScale = _currentScale;
  }
  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    //do not scale if not exactly 2 fingers on screen
    if (controller == null || _pointers != 2){
      return;
    }
    //this is for zooming in and out on the camera using ur fingers
    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  //control bar for taking the image
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.green,
          onPressed: cameraController != null
              && cameraController.value.isInitialized
              && !cameraController.value.isRecordingVideo
            ? onTakePictureButtonPressed : null,
        )


      ]
    );
  }

  Widget _cameraToggleRowWidget() {
    final List<Widget> toggles = <Widget>[];

    final onChanged = (CameraDescription? description){
      if (description == null){
        return;
      }
      onNewCameraSelected(description);
    };

    if (cameras.isEmpty){
      return const Text("No Cameras Found");
    }else{
      for (CameraDescription cameraDescription in cameras){
        toggles.add(
          SizedBox(
            width: 90,
            child: RadioListTile<CameraDescription>(
              title: (Text("This one")),
              groupValue: controller?.description,
              value: cameraDescription,
              onChanged: controller != null && controller!.value.isRecordingVideo ? null : onChanged,
            )
          )
        );
      }
    }
    return Row(children: toggles);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if(controller != null) {
      await controller!.dispose();
    }
    final CameraController cameraController = CameraController(
      cameraDescription, ResolutionPreset.medium, enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg
    );

    controller = cameraController;

    try {
      await cameraController.initialize();
      await Future.wait([ //min and max exposure neeeed to be added if I deem it nessessary for the camera
        cameraController.getMaxZoomLevel().then((value) => _maxAvailableZoom = value),
        cameraController.getMinZoomLevel().then((value) => _minAvailableZoom = value)
      ]);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if(mounted){
      setState(() {});
    }

  }

  void onTakePictureButtonPressed() {
    //XFile? file = controller.takePicture();
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          //removed videoController code as we will not be recording video
          //videoController?.dispose();
          //videoController = null;
        });
        if (file != null){
          showInSnackBar('Picture saved to ${file.path}');

          showDialog(
              context: context,
              builder: (_) => Dialog(
                child:
                  Image.file(File(file.path))
              )
          );
        }
      }
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized){
      showInSnackBar('Error: select Camera First');
      return null;
    }

    if (cameraController.value.isTakingPicture){
      return null; //capture already in process, so dont interupt
    }

    try{
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(e) {
    logError(e.code, e.description);
    showInSnackBar("Error: ${e.code}\n${e.description}");
  }

}
class FoodCamera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraFood(),
    );
  }
}
List<CameraDescription> cameras = [];

Future<void> main() async{
  //assign avaialbe camera
  print("Start");
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(FoodCamera());
}
// What's this??? This allows a value of typ T or T? to be treated as a val of type T?
// Why?? because this thing is not finished and more stable versions of the flutter camera API
// are not expected to release until late 2021
T? _ambiguate<T>(T? value) => value;