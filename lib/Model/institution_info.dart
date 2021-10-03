import 'package:plate_waste_recorder/Model/info.dart';

/// Class with basic information to represent an Institution, allows for easy display
/// of some high level Institution information and can be used to easily read
/// Institution objects in from our Database
class InstitutionInfo extends Info{
  String _institutionAddress;
  String name = "";
  String databaseKey = "";

  InstitutionInfo(String institutionName, this._institutionAddress){
    this.name = institutionName;
    this.databaseKey = this._institutionAddress;
  }

  String get institutionAddress{
    return this._institutionAddress;
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
        databaseKey = json["databaseKey"],
        _institutionAddress = json["_institutionAddress"];
}