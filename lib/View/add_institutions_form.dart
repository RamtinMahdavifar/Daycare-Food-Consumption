import 'package:flutter/material.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:flutter/services.dart';

class AddInstitutionForm extends StatefulWidget {
  @override
  _AddInstitutionFormState createState() => _AddInstitutionFormState();
}

class _AddInstitutionFormState extends State<AddInstitutionForm> {
  final _newInstitutionNameController = TextEditingController();
  final _newInstitutionAddressController = TextEditingController();
  final _newInstitutionSubjectController = TextEditingController();
  final _newInstitutionFormKey = GlobalKey<FormState>();
  bool _nameFieldValid = true;
  bool _addressFieldValid = true;
  bool _subjectNumberFieldValid = true;

  @override
  Widget build(BuildContext context) {
    Config.log.i("building add institution form widget");
    return Scaffold(
      body: Form(
          key: _newInstitutionFormKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                formEntry("name", const Icon(Icons.home), _newInstitutionNameController, this._nameFieldValid),
                formEntry("address", const Icon(Icons.location_on_outlined), _newInstitutionAddressController, this._addressFieldValid),
                // use an accessibility icon for the number of subjects field as this particular icon looks like a person
                formEntry("# of subjects:", const Icon(Icons.accessibility_new_rounded), _newInstitutionSubjectController,
                    this._subjectNumberFieldValid, TextInputType.number, r"\d+"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [formCancel(context), formSubmit(context)],
                )
              ]
          )
      ),
     );
  }
  Widget formSubmit(BuildContext context){
    return ElevatedButton(
        onPressed: (){
          // validate form inputs manually as validate() function of form isn't working
          String newName = _newInstitutionNameController.value.text;
          String newAddress = _newInstitutionAddressController.value.text;
          String newNumberOfSubjectsInput = _newInstitutionSubjectController.value.text;

          Config.log.i("pressed button to submit add institution form with name: " + newName + " address: " + newAddress +
              " and number of subjects: " + newNumberOfSubjectsInput);

          setState((){
            // update our class variables from within setState so ui which may
            // depend upon these variables is also updated
            this._nameFieldValid = newName != null && newName.isNotEmpty;
            this._addressFieldValid = newAddress != null && newAddress.isNotEmpty;
            this._subjectNumberFieldValid = newNumberOfSubjectsInput != null && newNumberOfSubjectsInput.isNotEmpty;
          });

          if(this._nameFieldValid && this._addressFieldValid && this._subjectNumberFieldValid){
            Config.log.i("new institution fields valid");
            // convert our number of subjects field to an integer, we will always be able
            // to validly parse newNumberOfSubjectsInput as an integer as we ensure the user
            // can only input digits and no other symbols when giving us this value
            int newNumberOfSubjects = int.parse(newNumberOfSubjectsInput);
            // both input fields are valid, we can successfully create an institution
            // here we are using a dummy research group to add database values to until
            // authentication and research group creation is added
            Database().addInstitutionToResearchGroup(Institution(newName, newAddress, newNumberOfSubjects),
                ResearchGroupInfo("testResearchGroupName"));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Institution Created Successfully")),
            );
            // clear our text fields before exiting the add Institution popup
            this._newInstitutionNameController.clear();
            this._newInstitutionAddressController.clear();
            this._newInstitutionSubjectController.clear();
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
          this._newInstitutionSubjectController.clear();
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text("Cancel")
    );
  }

  // has optional parameter keyboardType with default value TextInputType.text, ie
  // formEntries use text keyboards by default, following this optional parameter is a
  // second optional parameter indicating the regular expression to be used to whitelist
  // the characters entered into the field, by default this regular expression is .* allowing
  // all characters
  Widget formEntry(String labelName, Icon icon, TextEditingController controller, bool fieldIsValid,
    [TextInputType keyboardType = TextInputType.text, String validInputRegularExpression = r".*"]){
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
      keyboardType: keyboardType,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(validInputRegularExpression))]
    );
  }

  @override
  void dispose(){
    // dispose of created text controllers to avoid memory leaks
    this._newInstitutionAddressController.dispose();
    this._newInstitutionNameController.dispose();
    this._newInstitutionSubjectController.dispose();
    super.dispose();
  }

}


