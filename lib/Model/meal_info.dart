import 'package:plate_waste_recorder/Model/info.dart';

enum MealType{ // TODO: consider whether we want meal types to be stored as part of the info
  before,
  after
}
/// Class with basic information to represent an Meal, allows for easy display
/// of some high level Meal information and can be used to easily read
/// Meal objects in from our Database
class MealInfo extends Info{
  String _mealId = "";
  String databaseKey = "";
  String name = "";

  MealInfo(String mealId, String mealName){
    assert(mealId.isNotEmpty);
    assert(mealName.isNotEmpty);
    this._mealId = mealId;
    this.databaseKey = this._mealId;
    this.name = mealName;
  }

  String get mealId{
    return this._mealId;
  }

  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      MealInfo otherInfo = other as MealInfo;
      return this._mealId == otherInfo._mealId &&
      this.databaseKey == otherInfo.databaseKey &&
      this.name == otherInfo.name;
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'mealId': this._mealId,
    'databaseKey': this.databaseKey,
    'name': this.name
  };

  // this is considered a constructor and so cannot be inherited from our super Info
  MealInfo.fromJSON(Map<String, dynamic> json)
      : this._mealId = json['mealId'].toString(),
        this.databaseKey = json['databaseKey'].toString(),
        this.name = json['name'].toString();
}