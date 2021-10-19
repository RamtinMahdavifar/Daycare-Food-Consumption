import 'package:plate_waste_recorder/Model/info.dart';

/// Class with basic information to represent an Institution, allows for easy display
/// of some high level Institution information and can be used to easily read
/// Institution objects in from our Database
class InstitutionInfo extends Info{

  String _institutionAddress = "";
  String name = "";
  String databaseKey = "";

  InstitutionInfo(String institutionName, String institutionAddress){
    assert(institutionName.isNotEmpty);
    assert(institutionAddress.isNotEmpty);
    this.name = institutionName;
    this._institutionAddress = institutionAddress;
    this.databaseKey = this._institutionAddress;
  }

  String get institutionAddress{
    return this._institutionAddress;
  }

  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      InstitutionInfo otherInfo = other as InstitutionInfo;
      return this.name == otherInfo.name &&
          this.databaseKey == otherInfo.databaseKey &&
          this._institutionAddress == otherInfo._institutionAddress;
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': this.name,
    'databaseKey': this.databaseKey,
    '_institutionAddress': this._institutionAddress,
  };

  // this is considered a constructor and so cannot be inherited from our super Info
  InstitutionInfo.fromJSON(Map<String, dynamic> json)
      : name = json["name"].toString(),

        databaseKey = json["databaseKey"] as String,
        _institutionAddress = json["_institutionAddress"] as String;
}