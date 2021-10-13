
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';

/// Class representing an institution, institutions are considered to be anywhere where
/// data collection in a plate waste study might be undertaken
class Institution {
  String _name;
  String _address;
  // map with string keys denoting the IDs of the subjects in the institution,
  // values in this map are SubjectInfo objects with additional information about
  // each subject in the institution
  Map<String, SubjectInfo> _subjectsMap = {};


  // Institution constructor
  Institution(this._name, this._address);

  String get name{
    Config.log.i('Getting institution name: $_name');
    return this._name;
  }

  String get address{
    return this._address;
  }

  set name(String newName){
    this._name = newName;
  }

  set address(String newAddress){
    this._address = newAddress;
  }
  
  InstitutionInfo getInstitutionInfo(){
    return InstitutionInfo(this.name, this.address);
  }

  void addSubjectToInstitution(SubjectInfo newSubjectInfo){
    // make sure the id of the subject being added is not an empty string
    // this object is created with null safety and cannot be null
    assert(newSubjectInfo.subjectId.isNotEmpty);
    // ensure there is no subject within our institution with the same id as this new subject
    assert(this._subjectsMap.containsKey(newSubjectInfo.subjectId));
    // add the new subject
    this._subjectsMap[newSubjectInfo.subjectId] = newSubjectInfo;
  }

  // TODO: implement subject removal

  bool institutionContainsSubject(String subjectID){
    assert(subjectID.isNotEmpty);
    return this._subjectsMap.containsKey(subjectID);
  }

  SubjectInfo? getInstitutionSubject(String subjectID){
    // ensure our input subject id is not empty and corresponds to a subject in this
    // institution
    assert(subjectID.isNotEmpty);
    assert(this._subjectsMap.containsKey(subjectID));

    // this is a type SubjectInfo? as this can be null if the subject ID isn't present
    // in our institution even though we check this case, this type is required to
    // satisfy the compiler
    return this._subjectsMap[subjectID];
  }

  // TODO: update JSON operations
  Map<String, dynamic> toJson() => {
    '_name': this._name,
    '_address': this._address,
  };

  Institution.fromJSON(Map<String, dynamic> json)
  : _name = json["_name"].toString(), _address = json["_address"].toString();

  // define the equality operator
  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      Institution otherInstitution = other as Institution;
      return this._name == otherInstitution._name &&
          this._address == otherInstitution._address;
    }
    return false;
  }

}