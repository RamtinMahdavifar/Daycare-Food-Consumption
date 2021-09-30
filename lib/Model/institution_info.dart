import 'package:plate_waste_recorder/Model/info.dart';

class InstitutionInfo extends Info{
  String _institutionAddress;

  InstitutionInfo(String institutionName, this._institutionAddress){
    this.name = institutionName;
    this.databaseKey = this._institutionAddress;
  }
}