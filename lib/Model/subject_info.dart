import 'package:plate_waste_recorder/Model/info.dart';


/// Class with basic information to represent an Meal, allows for easy display
/// of some high level Meal information and can be used to easily read
/// Meal objects in from our Database
class SubjectInfo extends Info{
  int _subjectID = 0;
  String databaseKey = "";

  SubjectInfo(int subjectId){
    this._subjectID = subjectId;
    this.databaseKey = this._subjectID as String;
  }

  int get subjectId{
    return this._subjectID;
  }


  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){

      SubjectInfo otherInfo = other as SubjectInfo;
      return this._subjectID == otherInfo._subjectID &&
          this.databaseKey == otherInfo.databaseKey;

    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'subjectId': this._subjectID,
    'databaseKey': this.databaseKey,
  };

  // this is considered a constructor and so cannot be inherited from our super Info
  SubjectInfo.fromJSON(Map<String, dynamic> json)
      : _subjectID = json['subjectId'].toString() as int,
        databaseKey = json['databaseKey'].toString();
}