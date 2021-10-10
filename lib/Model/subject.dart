

import 'package:plate_waste_recorder/Model/meal.dart';



/// Class representing a subject, a subject is considered a student or research
/// participant over which research is being done.
class Subject{
  int _subjectID;

  Map<int,Meal> _mealMap = Map();

  Subject(this._subjectID);

  int get id{
    return this._subjectID;
  }

  Map<int,Meal> get meals{
    return this._mealMap;
  }

  void addNewMeal(Meal newMeal){

    this._mealMap[newMeal.id] = newMeal;
  }

  void removeMeal(Meal removeMeal){
    this._mealMap.remove(removeMeal.id);
  }

}