import 'package:plate_waste_recorder/Model/info.dart';


/// Class with basic information to represent a Subject, allows for easy display
/// of some high level Subject information, can be used to easily read
/// Subject objects in from our Database
class SubjectInfo extends Info{
  String _subjectID = "";
  String databaseKey = "";

  SubjectInfo(String subjectId){
    this._subjectID = subjectId;
    this.databaseKey = this._subjectID as String;
  }

  String get subjectId{
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
      : _subjectID = json['subjectId'].toString(),
        databaseKey = json['databaseKey'].toString();
}