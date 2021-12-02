import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import "../Model/variables.dart";
import 'camera_food2.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';
import 'package:responsive_flutter/responsive_flutter.dart';

Widget inputIDButton(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  //It displays a button to manually input the id
  //PreCond:
  //          1. Requires context of current page,
  //

  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button open a popup window to take the user input for ID
  return SizedBox(
      height: height / 12,
      width: width / 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 5),
              borderRadius: new BorderRadius.circular(3)),
        ),
        child: Text("Manual ID Entry", style: TextStyle(fontSize: 32)),
        onPressed: () {
          //await reassemble();
          Navigator.push(context, MaterialPageRoute(//open new one to scan
              builder: (context) {
            return InputIDForm(); //open the Input id pop box
          }));
        },
      ));
}

class InputIDForm extends StatefulWidget {
  //Widget to input the student/QR id manually

  @override
  _InputIDFormState createState() => _InputIDFormState();
}

class _InputIDFormState extends State<InputIDForm> {
  //Creates a form to take user input
  final _newIdInputController = TextEditingController();
  final _newIdInputFormKey = GlobalKey<FormState>();
  bool _IdInputFieldValid = true;

  @override
  Widget build(BuildContext context) {
    Config.log.i("building add institution form widget");
    return AlertDialog(
      content: Stack(
        // overflow: Overflow.visible,
        children: <Widget>[
          Form(
            key: _newIdInputFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: formEntry("ID", const Icon(Icons.perm_identity),
                      _newIdInputController, this._IdInputFieldValid),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    formCancel(context),
                    formSubmit(context)
                  ], //buttons to perform operations to cancel or submit the input
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget formSubmit(BuildContext context) {
    //It displays a form submit button and validates the user input
    //PreCond:
    //          1. Requires context of current page
    //
    //PostCond:
    //          1. Button is displayed on the page
    //          2. On press the button validates the user input and if its not empty then record exists then it opens
    //             camera for empty food state to take pictures

    return ElevatedButton(
        onPressed: () {
          // validate form inputs manually as validate() function of form isn't working
          String newId = _newIdInputController.value.text;

          Config.log.i(
              "pressed button to submit add input id form with student id: " +
                  newId);

          setState(() {
            // update our class variables from within setState so ui which may
            // depend upon these variables is also updated
            this._IdInputFieldValid = newId != null && newId.isNotEmpty;
          });

          if (this._IdInputFieldValid) {
            Config.log.i("user entered id: " + newId);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Opening the Camera")),
            );
            // clear our text fields before exiting the add Institution popup
            this._newIdInputController.clear();
            Navigator.of(context, rootNavigator: true).pop();
            setIDVar(newId);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              //reassemble();
              if (getStatus() == "uneaten") {
                return CameraFood2();
              } else if (getStatus() == "eaten") {
                return CameraFood2();
              } else if (getStatus() == "container") {
                return CameraFood2();
              } else {
                throw Exception("Invalid Food State");
              }

              // on qr found, take to food data input screen, this will be
              // modified to account for viewing id data and the two different
              // food data input screens
            }));
          } else {
            Config.log.w("User Id not valid");
          }
        },
        child: const Text("Submit"));
  }

  Widget formCancel(BuildContext context) {
    //It displays a form cancel button to close the input pop
    //PreCond:
    //          1. Requires context of current page
    //
    //PostCond:
    //          1. Button is displayed on the page
    //          2. On press the button navigates back to the previous page
    return ElevatedButton(
        onPressed: () {
          Config.log.i("cancelling form submission");
          // clear the text fields before exiting the add Institution popup
          this._newIdInputController.clear();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Cancel"));
  }

  Widget formEntry(String labelName, Icon icon,
      TextEditingController controller, bool fieldIsValid) {
    //It displays a form entry field to take user input
    //PreCond:
    //          1. Requires context of current page
    //          2. Icon to display
    //             3. Controller for text field
    //             4. Boolen to check if field is valid
    //
    //PostCond:
    //          1. text input field is displayed on the page
    //          2. Validates and warn user if field is left empty
    assert(labelName.isNotEmpty);

    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'missing fields';
        }
        return null;
      },
      decoration: InputDecoration(
          icon: icon,
          labelText: labelName,
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value Can't Be Empty" : null),
      controller: controller,
    );
  }

  @override
  void dispose() {
    // dispose of created text controllers to avoid memory leaks
    this._newIdInputController.dispose();
    super.dispose();
  }
}

Widget manualInput(BuildContext context, String btnName, Widget Function() page,
    int iconIndex) {
  //It displays a a button to input the id manually
  //PreCond:
  //          1. Requires context of current page,
  //          2. Button name as an string which should not be empty
  //          3. Page function to navigate to the next page
  //          4. icon index to display the button icon
  //
  //PostCond:
  //          1. Button is displayed on the page
  //          2. On press the button opens the next page (manual id popup)

  assert(btnName.isNotEmpty);
  assert(iconIndex >= 0);
  return Flexible(
      child: SizedBox(
          height: 140,
          width: 300,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return page();
                }));
              },
              child: Column(children: <Widget>[
                Text(
                  btnName,
                  style: TextStyle(
                    fontSize: ResponsiveFlutter.of(context)
                        .fontSize(4), // insert your font size here
                  ),
                ),
                Icon(
                  categories[iconIndex].icon,
                  color: Colors.orange,
                  size: 50.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                )
              ]))));
}
