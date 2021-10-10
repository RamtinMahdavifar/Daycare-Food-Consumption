import 'package:plate_waste_recorder/Model/info.dart';

enum MealType{
  before,
  after
}
/// Class with basic information to represent an Meal, allows for easy display
/// of some high level Meal information and can be used to easily read
/// Meal objects in from our Database
class MealInfo extends Info{
  int _mealId = 0;
  String _imagePath ="";
  MealType _mealType = MealType.before;
  String _comment = "";
  String databaseKey = "";

  MealInfo(int mealId,String photoPath, MealType mealType,String comment){

    this._mealId = mealId;
    this._imagePath = photoPath;
    this._mealType = mealType;
    this._comment = comment;
    this.databaseKey = this._mealId as String;
  }

  int get mealId{
    return this._mealId;
  }

  String get comment{
    return this._comment;
  }

  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){

      MealInfo otherInfo = other as MealInfo;
      return this._mealId == otherInfo._mealId &&
      this._imagePath == otherInfo._imagePath &&
      this._mealType == otherInfo._mealType &&
      this._comment == otherInfo._comment &&
      this.databaseKey == otherInfo.databaseKey;

    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'mealId': this._mealId,
    'databaseKey': this.databaseKey,
    'comments': this._comment,
    'image': this._imagePath,
    'mealType':this._mealType,
  };

  // this is considered a constructor and so cannot be inherited from our super Info
  MealInfo.fromJSON(Map<String, dynamic> json)
      : _mealId = json['mealId'].toString() as int,
        databaseKey = json['databaseKey'].toString(),
        _comment = json['comments'].toString(),
        _imagePath = json['image'].toString(),
        _mealType = json['mealType'] as MealType;
}