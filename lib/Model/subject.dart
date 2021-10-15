import 'dart:convert';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:plate_waste_recorder/Helper/date_converter.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';

/// Class representing a subject, a subject is considered a student or research
/// participant over which research is being done.
class Subject{
  //*****subject properties******

  // subject ID
  late String _subjectID;

  // map of subject meals, this map will have date string keys, values will be maps
  // with string meal IDs as keys and corresponding MealInfos as values. The idea here is
  // to organize the meals by the date they were recorded, here we can easily get a map
  // of all meals recorded for a given date.
  Map<String,Map<String,MealInfo>> _mealMap = Map();



  //**********subject  constructor*************
  Subject(String subjectID){
    assert(subjectID.isNotEmpty);
    this._subjectID = subjectID;
  }


  //Subject getters

  //get subject ID
  String get id{
    return this._subjectID;
  }

  /// returns a List<MealInfo> of MealInfo objects the subject has been served on the
  /// day represented by the input string
  /// Preconditions: dateString.isNotEmpty && subjectHasMealsForDate(dateString)
  /// Postconditions: returns a list of MealInfo objects the subject has been served
  /// on the date represented by dateString. dateString must have the format yyyy-MM-dd, where
  /// yyyy are numbers representing the year of the desired date, MM are numbers representing the month (1-12)
  /// of the desired date, and dd are numbers representing the day of the month of the desired date
  /// ie 1-31 for October, 1-30 for November etc
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
    return mealMapForSpecifiedDay!.values.toList();
  }

  /// returns true if the subject has been served a meal on the date represented by
  /// dateString
  /// Preconditions: dateString.isNotEmpty, dateString must have the format yyyy-MM-dd, where
  /// yyyy are numbers representing the year of the desired date, MM are numbers representing the month (1-12)
  /// of the desired date, and dd are numbers representing the day of the month of the desired date
  /// ie 1-31 for October, 1-30 for November etc
  /// Postconditions: returns true if the subject has any meals stored for the date
  /// specified by dateString, false otherwise
  bool subjectHasMealsForDate(String dateString){
    // ensure the input dateString is not empty
    assert(dateString.isNotEmpty);
    return this._mealMap.containsKey(dateString);
  }

  /// adds a the input meal to the subject for the specified DateTime
  /// Preconditions: meal.id.isNotEmpty
  /// Postconditions: stores the input meal for this subject under the specified date
  /// such that getSubjectMealsForDate(dateString) returns a list containing the input meal,
  /// here dateString is the string representation of date
  void addSubjectMealForDate(DateTime date, Meal meal){
    // ensure the mandatory fields of our meal are not empty
    assert(meal.id.isNotEmpty);
    // TODO: consider date validation
    // convert the input date into a string
    String dateString = convertDateToString(date);

    // get a MealInfo object from the input Meal
    MealInfo newMealInfo = meal.getMealInfo();

    // if the subject already has meals for the input date add this meal to the
    // existing meal map for that date
    if(this._mealMap.containsKey(dateString)){
      Config.log.i("adding additional meal: " + meal.id + " for subject: " + this.id + " on date: " + dateString);
      Map<String,MealInfo>? existingMapForDate = this._mealMap[dateString];
      existingMapForDate![newMealInfo.databaseKey] = newMealInfo;
    }
    else{
      Config.log.i("adding new meal: " + meal.id + " for subject: " + this.id + " on date: " + dateString);
      Map<String,MealInfo> newMapForDate = {newMealInfo.databaseKey: newMealInfo};
      // add the newly created map to the subject's mealMap
      this._mealMap[dateString] = newMapForDate;
    }
  }

  /// returns true if the subject has any meals at all regardless of date,
  /// Preconditions: None
  /// Postconditions: returns true if the subject has any meal stored, regardless of
  /// the dates these meals may be stored under
  bool subjectHasMeals(){
    return this._mealMap.isNotEmpty;
  }

  /// returns a list of Strings where each string is a date the subject has been
  /// served a meal.
  /// Preconditions: this.subjectHasMeals()
  /// Postconditions: returns a list of Strings where each String represents a date
  /// the subject has a meal stored for, each string has the format yyyy-MM-dd, where
  /// yyyy are numbers representing the year of the desired date, MM are numbers representing the month (1-12)
  /// of the desired date, and dd are numbers representing the day of the month of the desired date
  /// ie 1-31 for October, 1-30 for November etc
  List<String> getSubjectMealDates(){
    // ensure our subject actually has meals to retrieve dates for
    assert(this.subjectHasMeals());
    // if the subject has meals, the keys of this subject's mealMap will be the
    // dates the subject had such meals, simply return this
    return this._mealMap.keys.toList();
  }

  /// returns a SubjectInfo object such that the subjectID field of this SubjectInfo is
  /// this._subjectID
  /// Preconditions: this._subjectID.isNotEmpty
  /// Postconditions: returns a SubjectInfo specified above
  SubjectInfo getSubjectInfo(){
    // ensure this object has a legitimate subjectID before creating this info
    assert(this._subjectID.isNotEmpty);
    return SubjectInfo(this._subjectID);
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
      return this._subjectID == otherInfo._subjectID;
             // TODO: factor meal map into equality, default map equality is object
             // TODO: equality, need to check each key-value mapping manually for equality
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