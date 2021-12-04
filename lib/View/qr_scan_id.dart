import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'food_capture.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';



/// this is the Qr reading screen, here a viewfinder is built, it scans for an
/// ID and depending on the context of why a QR is being scanned, ie the foodStatus
/// it will redirect to the camera screen for data input, or to the view data
/// screen
class QR_ScanID extends StatefulWidget { // TODO: why is there an _ in this name

  InstitutionInfo currentInstitution;
  FoodStatus currentFoodStatus;
  QR_ScanID(this.currentInstitution, this.currentFoodStatus, {Key? key}) : super(key: key);

  @override
  State<QR_ScanID> createState() => _QR_ScanIDState();
}

class _QR_ScanIDState extends State<QR_ScanID> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    Config.log.i("building id input page");
    return Container(
      child: BuildQrView(context),
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

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
      if (this.controller != null) {
        this.controller!.flipCamera();
      } else {
        Config.log.i("null controller used");
      }
    });


    controller.scannedDataStream.listen((scanData) async {
      Config.log.i("scanned subject ID ${scanData.code} from QR code");
      controller.stopCamera();

      // use our retrieved subject ID to construct a subjectInfo object
      // TODO: ensure subject with this code actually exists
      SubjectInfo targetSubjectInfo = SubjectInfo(scanData.code);

      await Database().institutionHasSubject(
          ResearchGroupInfo("testResearchGroupName"), widget.currentInstitution,
          targetSubjectInfo).then((subjectExists) {
        if (subjectExists) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if (widget.currentFoodStatus == FoodStatus.view) {
                  // we simply want to view data here, go the meal data page
                  return FoodCapture(
                      widget.currentInstitution, targetSubjectInfo, widget
                      .currentFoodStatus); //TODO change this to view data page of scanned ID
                } else {
                  // our FoodStatus must be eaten, uneaten or container, here we want to input data for these states
                  // navigate to the meal input page
                  return FoodCapture(
                      widget.currentInstitution, targetSubjectInfo,
                      widget.currentFoodStatus);
                }
                // on qr found, take to food data input screen, this will be
                // modified to account for viewing id data and the two different
                // food data input screens
              }));
        }
        else {
          Config.log.w(
              "Input User Id not valid, doesn't correspond to subject within institution");
          controller.resumeCamera();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: const Duration(seconds: 2),content: Text(
              "ID does not belong to: ${widget.currentInstitution.name}")));
        };
      });
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
}
