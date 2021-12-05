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
  // map with string keys denoting the IDs of the subjects in the institution,
  // values in this map are SubjectInfo objects with additional information about
  // each subject in the institution
  Map<String, SubjectInfo> _subjectsMap = {};


  // Institution constructor
  Institution(String name, String address, int numberOfSubjects){
    assert(name.isNotEmpty);
    assert(address.isNotEmpty);
    // ensure we've entered a non-negative number of subjects
    assert(numberOfSubjects>=0);
    this._name = name;
    this._address = address;
    _generateSubjects(numberOfSubjects);
  }


  /// Private helper function used to generate the IDs for each subject in a newly created institution
  /// a Subject object is created for each generated ID
  /// Preconditions: numberOfSubjects>0, subjects have not been generated for this Institution yet
  /// ie this._subjectsMap.isEmpty
  /// Postconditions: this.numberOfSubjects Subject objects are created and stored as values
  /// in this._subjectsMap, each subject is associated with it's corresponding generated id in this map,
  /// ie generated subject IDs are keys to this._subjectsMap, where values of this map are Subject objects
  /// who have that ID. Each generated ID should be globally unique.
  void _generateSubjects(int numberOfSubjects){
    assert(this._subjectsMap.isEmpty);
    int subjectIndex = 0; // TODO, do we even need number of subjects or just pass this as a parameter to this function
    // TODO: we can just get the number of subjects from the number of values or keys later
    while(subjectIndex < numberOfSubjects){
      String subjectID = _generateSubjectID(subjectIndex.toString());
      this._subjectsMap[subjectID] = SubjectInfo(subjectID);
      subjectIndex++;
    }
    // TODO: call some database method to add generated subjects to Institution on DB and create and write
    // TODO: a map of subjects for this institution to the DB under storage
  }

  /// Creates and returns a new, globally unique subject ID
  String _generateSubjectID(String id){
    // currently a stub implementation
    // TODO: generate globally unique keys somehow, consider db reference.push().key() all operations are client side
    // TODO: should this be a static method of the Subject class, seems to make more sense
    // TODO: call subject() with no parameters and have subject simply generate it's own ID
    // TODO: that way subjects are forced to use this unique ID generation
    // TODO: do we even care about globally unique IDs
    return "ID $id";
  }

  Map<String, SubjectInfo> get subjectsMap{
    return this._subjectsMap;
  }

  String get name{
    return this._name;
  }

  String get address{
    return this._address;
  }

  int get numberOfSubjects{
    // the number of subjects will simply be the length of the map holding the subjects
    return this._subjectsMap.length;
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

  Map<String, dynamic> toJson() => {
    '_name': this._name,
    '_address': this._address,
    '_subjectsMap': this._subjectsMap
  };

  Institution.fromJSON(Map<String, dynamic> json)
      : _name = json["_name"].toString(), _address = json["_address"].toString(),
        _subjectsMap = json["_subjectsMap"]!=null ? (json["_subjectsMap"] as Map<String, dynamic>).map((key, value){
          return MapEntry<String, SubjectInfo>(key, SubjectInfo.fromJSON(value));
        }) : Map<String,SubjectInfo>();
  // here we need to convert each value of subjects map into a SubjectInfo object
  // by converting from JSON directly to a SubjectInfo, if we do not have a _subjectsMap
  // in our JSON ie json["_subjectsMap"] is null, then no subjects are defined for
  // this institution on our database simply create an empty subjects map

  // define the equality operator
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