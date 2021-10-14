import 'dart:convert';

import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:plate_waste_recorder/Helper/date_converter.dart';

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

  List<MealInfo> getSubjectMealsForDate(String dateString){
    // ensure the input dateString is not empty
    assert(dateString.isNotEmpty);
    // ensure the subject has meals for the specified date
    assert(this._mealMap.containsKey(dateString));
    Map<String,MealInfo>? mealMapForSpecifiedDay = this._mealMap[dateString];
    // include a null check here as mealMapForSpecifiedDay is a conditional variable
    // ie it is only non-null if dateString corresponds to some value in our map
    // since we check this as a precondition, mealMapForSpecifiedDay can never be null
    // return the values of this map which are the Info objects of the meals
    // given to this subject on the input date
    return mealMapForSpecifiedDay!.values as List<MealInfo>;
  }

  bool subjectHasMealsForDate(String dateString){
    // ensure the input dateString is not empty
    assert(dateString.isNotEmpty);
    return this._mealMap.containsKey(dateString);
  }

  void addSubjectMealForDate(DateTime date, Meal meal){
    // ensure the mandatory fields of our meal are not empty
    assert(meal.id.isNotEmpty && meal.mealName.isNotEmpty);
    // TODO: consider date validation
    // convert the input date into a string
    String dateString = convertDateToString(date);

    // get a MealInfo object from the input Meal
    MealInfo newMealInfo = meal.getMealInfo();

    // if the subject already has meals for the input date add this meal to the
    // existing meal map for that date
    if(this._mealMap.containsKey(dateString)){
      Map<String,MealInfo>? existingMapForDate = this._mealMap[dateString];
      existingMapForDate![newMealInfo.databaseKey] = newMealInfo;
    }
    else{
      Map<String,MealInfo> newMapForDate = {newMealInfo.databaseKey: newMealInfo};
      // add the newly created map to the subject's mealMap
      this._mealMap[dateString] = newMapForDate;
    }
  }

  bool subjectHasMeals(){
    return this._mealMap.isNotEmpty;
  }

  List<String> getSubjectMealDates(){
    // ensure our subject actually has meals to retrieve dates for
    assert(this.subjectHasMeals());
    // if the subject has meals, the keys of this subject's mealMap will be the
    // dates the subject had such meals, simply return this
    return this._mealMap.keys as List<String>;
  }



  //********Subject custom functions to update meals*******

  // remove a meal from existing meal map
  // TODO: consider, do we even want to allow users to remove subject meals
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
      return this._subjectID == otherInfo._subjectID &&
             this._mealMap == otherInfo._mealMap;
    }
    return false;
  }

  // TODO: update JSON operations
  @override
  Map<String, dynamic> toJson() => {
    '_subjectId': this._subjectID,
    '_mealMap': jsonEncode(this._mealMap)
  };

  
  Subject.fromJSON(Map<String, dynamic> json)
      : _subjectID = json['subjectId'].toString();

}