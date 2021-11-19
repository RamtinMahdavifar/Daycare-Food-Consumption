
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'name_suggest.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/rendering.dart';
import "../Model/variables.dart";
import 'package:plate_waste_recorder/Helper/config.dart';


class UneatenFoodDialog extends StatefulWidget {

  // take as parameters to this page the controller for our qr camera view
  // and the institution and subject info this meal belongs under
  QRViewController qrViewController;
  InstitutionInfo currentInstitution;
  SubjectInfo currentSubject;
  UneatenFoodDialog(this.qrViewController, this.currentInstitution, this.currentSubject, {Key? key}) : super(key: key);


  @override
  _UneatenFoodDialogState createState() => _UneatenFoodDialogState();
}

class _UneatenFoodDialogState extends State<UneatenFoodDialog> {
  List<String> exampleFoodItems = ["Apple", "Sandwich", "Juice"]; //for String foodItem in exampleFoodItems
  final nameTextController = new TextEditingController();
  final weightTextController = new TextEditingController(text: "69"); //this value of text would be the value returned by our scale
  final commentsTextController = new TextEditingController();

  //XFile? _imageFile;
  bool _nameFoodValid = true;
  bool _weightFoodValid = true;


  @override
  Widget build(BuildContext context) {
    print("Image submit dialog opens");
    //controller.pauseCamera();
    double w = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(w/2, 37, 0, 30), // bottom 30, top 37, these are precision measurements for all screens btw
        child:Dialog(
            elevation: 0,
            child: Form(
              //key: _newFoodItemKey,
                child: Scaffold(
                    body:
                    Center(
                        child: Column(
                          children: [
                            //nameEntrySuggester(nameTextController, _nameFoodValid),
                            suggestBox(context, nameTextController, _nameFoodValid),
                            itemPresets(nameTextController),
                            weightEntry(weightTextController, _weightFoodValid),
                            addComments(context, commentsTextController),
                            submitData(context, widget.qrViewController, nameTextController, weightTextController, commentsTextController),
                            retakePhoto(context, widget.qrViewController),
                          ],
                        )
                    )
                )
            )
        )
    );
  }

  Widget retakePhoto(BuildContext context, QRViewController controller){
    return ElevatedButton(
        onPressed: () {
          controller.resumeCamera();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Retake Photo"),
        style: ElevatedButton.styleFrom(primary: Colors.redAccent)
    );
  }

  Widget submitData(BuildContext context, QRViewController controller){
    return ElevatedButton(
        onPressed: () {
          //submit name - weight - ID - photo - comments - date - institution
          Config.log.i("User has pressed button to submit meal data");

          // extract relevant data from our fields for data submit

          // clear our text fields before returning to the previous screen after data submit
          this.nameTextController.clear();
          this.weightTextController.clear();
          this.commentsTextController.clear();
          // unpause our camera so the user can take successive pictures after data has been submitted
          controller.resumeCamera();
          // return to the previous screen/close this popup dialog
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Submit"),
        style: ElevatedButton.styleFrom(primary: Colors.lightGreen)
    );
  }

  Widget addComments(BuildContext context, TextEditingController controller) {
    return TextField(
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Comments'
      ),
      controller: controller,
    );
  }

  Widget itemPresets(TextEditingController controller) {
    List<Widget> presets = [];
    for (String foodItem in exampleFoodItems){
      presets.add(
          ElevatedButton(
              onPressed: () {controller.text = foodItem;} ,
              child: Text(foodItem)
          )
      );
    }
    return Row(children : presets);
  }

  Widget nameEntrySuggester(TextEditingController controller, bool fieldIsValid) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'missing fields';
        }
        return null;
      },
      decoration: InputDecoration(

          labelText: "Name of Food Item",
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value"
              "Can't Be Empty" : null
      ),

    );

  }

  Widget weightEntry(TextEditingController controller, bool fieldIsValid){

    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty){
          return 'missing fields';
        }
        return null;
      },
      decoration: InputDecoration(

          labelText: "Weight (g)",
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value"
              "Can't Be Empty" : null
      ),
      controller: controller,
    );

  }


}


