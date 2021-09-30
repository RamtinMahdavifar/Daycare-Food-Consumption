
/// Class representing an institution
class Institution {
  String _name;
  String _address;

  // Institution constructor
  Institution(this._name, this._address);

  String get name{
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
}