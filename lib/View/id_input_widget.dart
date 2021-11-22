import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import "../Model/variables.dart";
import 'camera_food2.dart';
import 'package:plate_waste_recorder/Helper/icons.dart';
import 'package:responsive_flutter/responsive_flutter.dart';



class InputIDForm extends StatefulWidget {
  @override
  _InputIDFormState createState() => _InputIDFormState();
}

class _InputIDFormState extends State<InputIDForm> {
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
                  child: formEntry("ID", const Icon(Icons.perm_identity), _newIdInputController, this._IdInputFieldValid),
                ),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [formCancel(context), formSubmit(context)],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget formSubmit(BuildContext context){
    return ElevatedButton(
        onPressed: (){
          // validate form inputs manually as validate() function of form isn't working
          String newId =  _newIdInputController.value.text;


          Config.log.i("pressed button to submit add input id form with student id: " + newId);

          setState((){
            // update our class variables from within setState so ui which may
            // depend upon these variables is also updated
            this._IdInputFieldValid = newId != null && newId.isNotEmpty;
          });

          if(this._IdInputFieldValid){
            Config.log.i("user entered id: "+ newId);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Opening the Camera" )),
            );
            // clear our text fields before exiting the add Institution popup
            this._newIdInputController.clear();
            Navigator.of(context, rootNavigator: true).pop();
            setIDVar(newId);
            Navigator.push(context, MaterialPageRoute(
                builder: (context){
                  //reassemble();
                  if (getStatus() == "uneaten"){
                    return CameraFood2();
                  }else if (getStatus() == "eaten"){
                    return CameraFood2();
                  }
                  else if (getStatus() == "container"){
                    return CameraFood2();
                  }
                  else{
                    throw Exception("Invalid Food State");
                  }

                  // on qr found, take to food data input screen, this will be
                  // modified to account for viewing id data and the two different
                  // food data input screens
                }));
          }
          else{
            Config.log.w("User Id not valid");
          }
        },
        child: const Text("Submit")
    );
  }

  Widget formCancel(BuildContext context){
    return ElevatedButton(
        onPressed: (){
          Config.log.i("cancelling form submission");
          // clear the text fields before exiting the add Institution popup
          this._newIdInputController.clear();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Cancel")
    );
  }

  Widget formEntry(String labelName, Icon icon, TextEditingController controller, bool fieldIsValid){
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty){
          return 'missing fields';
        }
        return null;
      },
      decoration: InputDecoration(
          icon: icon,
          labelText: labelName,
          // if the field isn't valid errorText has the value "Value Can't Be Empty"
          // otherwise errorText is null
          errorText: !fieldIsValid ? "Value Can't Be Empty" : null
      ),
      controller: controller,
    );
  }

  @override
  void dispose(){
    // dispose of created text controllers to avoid memory leaks
    this._newIdInputController.dispose();
    super.dispose();
  }

}


Widget manualInput(BuildContext context, String btnName, Widget Function() page,int iconIndex){
  return Flexible(
      child: SizedBox(
          height: 140,
          width: 300,
          child: ElevatedButton(
              onPressed: () {  Navigator.push(context, MaterialPageRoute(
                  builder: (context){
                    return page();
                  })); },
              child:Column(
                  children:  <Widget>[

                    Text(btnName,
                      style: TextStyle(
                        fontSize: ResponsiveFlutter.of(context).fontSize(4),// insert your font size here
                      ),),

                    Icon(
                      categories[iconIndex].icon,
                      color: Colors.orange,
                      size: 50.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )

                  ]

              )
          )

      )
  );
}

