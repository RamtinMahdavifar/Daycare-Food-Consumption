import 'dart:convert';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';

/// Class representing an institution, institutions are considered to be anywhere where
/// data collection in a plate waste study might be undertaken
class Institution {
  // these fields are late as such as this class's constructor doesn't take these fields
  // as input directly, this late keyword indicates that the fields will be initialized
  // before use as they are in our constructor
  late String _name;
  late String _address;
  late int _numberOfSubjects;
  // map with string keys denoting the IDs of the subjects in the institution,
  // values in this map are SubjectInfo objects with additional information about
  // each subject in the institution
  Map<String, SubjectInfo> _subjectsMap = {};


  // Institution constructor
  Institution(String name, String address, int numberOfSubjects){
    assert(name.isNotEmpty);
    assert(address.isNotEmpty);
    // ensure we've entered a non-negative number of subjects
    assert(numberOfSubjects>0);
    this._name = name;
    this._address = address;
    this._numberOfSubjects = numberOfSubjects;
  }


  void _generateSubjects(){

  }

  String get name{
    return this._name;
  }

  String get address{
    return this._address;
  }

  int get numberOfSubjects{
    return this._numberOfSubjects;
  }

  set name(String newName){
    assert(newName.isNotEmpty);
    this._name = newName;
  }

  set address(String newAddress){
    assert(newAddress.isNotEmpty);
    this._address = newAddress;
  }

  /// returns an InstitutionInfo object who has the same name and address of this
  /// Preconditions: this._name.isNotEmpty && this._address.isNotEmpty
  /// Postconditions: returns an InstitutionInfo object, such that the returned InstitutionInfo
  /// has this._name for it's name field and this._address for it's address field
  InstitutionInfo getInstitutionInfo(){
    // ensure this object has a legitimate name and address before creating this
    // info
    assert(this._name.isNotEmpty);
    assert(this._address.isNotEmpty);
    return InstitutionInfo(this.name, this.address);
  }

  /// Adds the input SubjectInfo object to this Institution,
  /// Preconditions: newSubjectInfo.subjectId.isNotEmpty, newSubjectInfo is not already
  /// contained within this institution, ie this.institutionContainsSubject(newSubjectInfo.subjectId) is false
  /// Postconditions: newSubjectInfo is added to this institution.
  void addSubjectToInstitution(SubjectInfo newSubjectInfo){
    // make sure the id of the subject being added is not an empty string
    // this object is created with null safety and cannot be null
    assert(newSubjectInfo.subjectId.isNotEmpty);
    // ensure there is no subject within our institution with the same id as this new subject
    assert(!this._subjectsMap.containsKey(newSubjectInfo.subjectId));
    Config.log.i("adding subject with id: " + newSubjectInfo.subjectId + " to institution: " + this._name);
    // add the new subject
    this._subjectsMap[newSubjectInfo.subjectId] = newSubjectInfo;
  }

  // TODO: implement subject removal

  /// returns true if the input subjectID corresponds to a SubjectInfo object who has
  /// been added to this institution
  /// Preconditions: subjectID.isNotEmpty
  /// Postconditions: returns true if there exists in this institution, some SubjectInfo
  /// object whose subjectID field is equal to the subjectID input.
  bool institutionContainsSubject(String subjectID){
    assert(subjectID.isNotEmpty);
    return this._subjectsMap.containsKey(subjectID);
  }

  /// returns the SubjectInfo object corresponding to the input subjectID, this returns a
  /// SubjectInfo? to comply with null safety, however the return value of this function can
  /// never be null
  /// Preconditions: subjectID.isNotEmpty, and institutionContainsSubject(subjectID) is true
  /// Postconditions: returns the SubjectInfo object who has the input subjectID from this institution
  SubjectInfo? getInstitutionSubject(String subjectID){
    // ensure our input subject id is not empty and corresponds to a subject in this
    // institution
    assert(subjectID.isNotEmpty);
    assert(this._subjectsMap.containsKey(subjectID));
    Config.log.i("retrieving subject with id: " + subjectID + " from institution: " + this._name);

    // this is a type SubjectInfo? as this can be null if the subject ID isn't present
    // in our institution even though we check this case, this type is required to
    // satisfy the compiler
    return this._subjectsMap[subjectID];
  }

  // TODO: update JSON operations
  Map<String, dynamic> toJson() => {
    '_name': this._name,
    '_address': this._address,
    '_numberOfSubjects': this._numberOfSubjects,
    '_subjectsMap': jsonEncode(this._subjectsMap)
  };

  Institution.fromJSON(Map<String, dynamic> json)
  : _name = json["_name"].toString(), _address = json["_address"].toString(), _numberOfSubjects = int.parse(json['_numberOfSubjects'].toString());

  // define the equality operator
  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      Institution otherInstitution = other as Institution;
      return this._name == otherInstitution._name &&
          this._address == otherInstitution._address &&
          this._numberOfSubjects == otherInstitution._numberOfSubjects;
    }
    return false;
  }

}