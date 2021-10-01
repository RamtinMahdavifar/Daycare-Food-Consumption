import 'package:plate_waste_recorder/Model/info.dart';

class InstitutionInfo extends Info{
  String _institutionAddress;
  String name = "";
  String databaseKey = "";

  InstitutionInfo(String institutionName, this._institutionAddress){
    this.name = institutionName;
    this.databaseKey = this._institutionAddress;
  }

  String get institutionAddress{
    return this.institutionAddress;
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