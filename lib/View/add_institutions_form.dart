import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/select_institution_widgets.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

class AddInstitutionForm extends StatefulWidget {
  @override
  _AddInstitutionFormState createState() => _AddInstitutionFormState();
}

class _AddInstitutionFormState extends State<AddInstitutionForm> {
  final _newInstitutionNameController = TextEditingController();
  final _newInstitutionAddressController = TextEditingController();
  final _newInstitutionFormKey = GlobalKey<FormState>();
  bool _nameFieldValid = true;
  bool _addressFieldValid = true;

  @override
  Widget build(BuildContext context) {
    Config.log.i("building add institution form widget");
    return MaterialApp(
      title: 'add institution form',
      home: Scaffold(
      body: Form(
          key: _newInstitutionFormKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                formEntry("name", const Icon(Icons.home), _newInstitutionNameController, this._nameFieldValid),
                formEntry("address", const Icon(Icons.location_on_outlined), _newInstitutionAddressController, this._addressFieldValid),
                //formEntry("other information", Icon(Icons.info_outline)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [formCancel(context), formSubmit(context)],
                )
              ]
          )
      ),
     ),
    );
  }
  Widget formSubmit(BuildContext context){
    return ElevatedButton(
        onPressed: (){
          // validate form inputs manually as validate() function of form isn't working
          String newName = _newInstitutionNameController.value.text;
          String newAddress = _newInstitutionAddressController.value.text;

          Config.log.i("pressed button to submit add institution form with name: " + newName + " and address: " + newAddress);

          setState((){
            // update our class variables from within setState so ui which may
            // depend upon these variables is also updated
            this._nameFieldValid = newName != null && newName.isNotEmpty;
            this._addressFieldValid = newAddress != null && newAddress.isNotEmpty;
          });

          if(this._nameFieldValid && this._addressFieldValid){
            Config.log.i("new institution fields valid");
            // both input fields are valid, we can successfully create an institution
            // here we are using a dummy research group to add database values to until
            // authentication and research group creation is added
            Database().addInstitutionToResearchGroup(Institution(newName, newAddress), ResearchGroupInfo("testResearchGroupName"));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Institution Created Successfully")),
            );
            // clear our text fields before exiting the add Institution popup
            this._newInstitutionNameController.clear();
            this._newInstitutionAddressController.clear();
            Navigator.of(context, rootNavigator: true).pop();
          }
          else{
            Config.log.w("new institution fields are not valid");
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
          this._newInstitutionNameController.clear();
          this._newInstitutionAddressController.clear();
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
    this._newInstitutionAddressController.dispose();
    this._newInstitutionNameController.dispose();
    super.dispose();
  }

}


