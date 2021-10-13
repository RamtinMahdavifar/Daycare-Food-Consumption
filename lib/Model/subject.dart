import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';

/// Class representing a subject, a subject is considered a student or research
/// participant over which research is being done.
class Subject{
  //*****subject properties******

  // subject ID
  String _subjectID;

  // map of subject meals, this map will have date string keys, values will be maps
  // with string meal IDs as keys and corresponding MealInfos as values. The idea here is
  // to organize the meals by the date they were recorded, here we can easily get a map
  // of all meals recorded for a given date.
  Map<String,Map<String,MealInfo>> _mealMap = Map();



  //**********subject  constructor*************
  Subject(this._subjectID);


  //Subject getters

  //get subject ID
  String get id{
    return this._subjectID;
  }

  //get subject Meals map
  /*
  Map<int,Meal> get meals{
    return this._mealMap;
  }
   */



  //********Subject custom functions to update meals*******

  //add a new meal in subject meal map
  void addNewMeal(Meal newMeal){

    this._mealMap[newMeal.id] = newMeal;
  }

  // remove a meal from exisitng meal map
  void removeMeal(Meal removeMeal){
    if(this._mealMap.containsKey(removeMeal.id)){
      this._mealMap.remove(removeMeal.id);
    }else {
      //TODO: Add a log msg for no meal exist with given id to remove
    }
  }

  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){

      Subject otherInfo = other as Subject;
      return this._subjectID == otherInfo._subjectID;

    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'subjectId': this._subjectID,
  };

  
  Subject.fromJSON(Map<String, dynamic> json)
      : _subjectID = json['subjectId'].toString();

}