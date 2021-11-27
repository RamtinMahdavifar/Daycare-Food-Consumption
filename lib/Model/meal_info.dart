import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/info.dart';

/// Class with basic information to represent an Meal, allows for easy display
/// of some high level Meal information and can be used to easily read
/// Meal objects in from our Database
class MealInfo extends Info{
  String _mealId = "";
  String databaseKey = "";
  String name = "";
  late FoodStatus _mealStatus;

  MealInfo(String mealId, String mealName, FoodStatus mealStatus){
    assert(mealId.isNotEmpty);
    assert(mealName.isNotEmpty);
    // ensure the food status refers to a legitimate state for our food, ie a Meal
    // object itself should never have the view status which is only used to view meals after submission
    assert(mealStatus == FoodStatus.eaten || mealStatus == FoodStatus.uneaten || mealStatus == FoodStatus.container);
    this._mealId = mealId;
    this.databaseKey = this._mealId;
    this.name = mealName;
    this._mealStatus = mealStatus;
  }

  String get mealId{
    return this._mealId;
  }

  FoodStatus get mealStatus{
    return this._mealStatus;
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
    '_mealId': this._mealId,
    'databaseKey': this.databaseKey,
    'name': this.name,
    '_mealStatus': this.mealStatus
  };

  // this is considered a constructor and so cannot be inherited from our super Info
  MealInfo.fromJSON(Map<String, dynamic> json)
      : this._mealId = json['_mealId'].toString(),
        this.databaseKey = json['databaseKey'].toString(),
        this.name = json['name'].toString(),
        this._mealStatus = json['_mealStatus'] as FoodStatus;
}