
import 'package:logger/logger.dart';
import 'package:plate_waste_recorder/Helper/logger_printer.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';

/// Class representing an institution, institutions are considered to be anywhere where
/// data collection in a plate waste study might be undertaken
class Institution {
  String _name;
  String _address;
  final log = Logger( level:Level.verbose, printer: SimpleLogPrinter('Institution'));

  // Institution constructor
  Institution(this._name, this._address);

  String get name{
    log.i('Getting institution name: $_name');
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