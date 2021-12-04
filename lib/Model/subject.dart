import 'dart:convert';
import 'package:plate_waste_recorder/Model/subject_info.dart';

/// Class representing a subject, a subject is considered a student or research
/// participant over which research is being done.
class Subject{
  //*****subject properties******

  // subject ID
  late String _subjectID;



  //**********subject  constructor*************
  Subject(String subjectID){
    assert(subjectID.isNotEmpty);
    this._subjectID = subjectID;
  }


  //Subject getters

  //get subject ID
  String get id{
    return this._subjectID;
  }

  /// returns a SubjectInfo object such that the subjectID field of this SubjectInfo is
  /// this._subjectID
  /// Preconditions: this._subjectID.isNotEmpty
  /// Postconditions: returns a SubjectInfo specified above
  SubjectInfo getSubjectInfo(){
    // ensure this object has a legitimate subjectID before creating this info
    assert(this._subjectID.isNotEmpty);
    return SubjectInfo(this._subjectID);
  }

  // TODO: update JSON operations
  // @override
  Map<String, dynamic> toJson() => {
    '_subjectId': this._subjectID
  };

  
  Subject.fromJSON(Map<String, dynamic> json)
      : _subjectID = json['subjectId'].toString();

}