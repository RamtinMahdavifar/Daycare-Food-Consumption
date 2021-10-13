import 'package:plate_waste_recorder/Model/meal_info.dart';


enum MealType{
  before,
  after
}

/// Class representing a Meal served to a particular subject
/// a subject can have multiple meals in a day and multiple meals throughout time
class Meal{
  //**** Meal Properties ********

  //Meal Id, unique ID for each meal
  int _mealId;

  // Images are converted to strings when stored, this is the string representing
  // the image of the meal before being eaten by a subject
  String _beforeImageAsString;

  // String representing the image of the meal after being eaten by the subject
  String _afterImageAsString;


  //Meal type its and enum from Meal class which has value before and after
  MealType _mealType;

  // double precision value recording the weight of the meal before being eaten
  double _beforeMealWeight;

  // double precision value recording the weight of the meal after being eaten
  double _afterMealWeight;

  // Comment associated with this particular meal, can be added to give additional
  // context or information about a meal
  late String _comment;


  //***** Meal constructor ********
  Meal(this._mealId,this._imagePath,this._mealType);


  //****** Meal getters **********

  //Meal Id
  int get id{
    return this._mealId;
  }

  //Meal photo
  String get image{
    return this._imagePath;
  }

  //meal comment
  String get comment{
    return this._comment;
  }

  //meal type
  MealType get mealType{
    return this._mealType;
  }

  //***** Meal setters ******

  //Set Meal comments
  set comment(String newComment){
    this._comment = newComment;
  }

  //****** Meal Custom methods *****

  //remove a comment
  void removeComment(){
    if (this._comment.length > 0){
      this._comment ="";
    }else {
      //TODO: Add a log msg for no comment exist to remove
    }
  }

  MealInfo getMealInfo(){
    return MealInfo()
  }


  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){

      Meal otherInfo = other as Meal;
      return this._mealId == otherInfo._mealId &&
          this._imagePath == otherInfo._imagePath &&
          this._mealType == otherInfo._mealType &&
          this._comment == otherInfo._comment;

    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'mealId': this._mealId,
    'comments': this._comment,
    'image': this._imagePath,
    'mealType':this._mealType,
  };


  Meal.fromJSON(Map<String, dynamic> json)
      : _mealId = json['mealId'].toString() as int,
        _comment = json['comments'].toString(),
        _imagePath = json['image'].toString(),
        _mealType = json['mealType'] as MealType;
}