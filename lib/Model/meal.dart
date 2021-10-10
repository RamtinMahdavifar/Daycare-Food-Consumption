



enum MealType{
  before,
  after
}

/// Class representing a Meal, which the food east by a subject
/// a subject can have multiple meals in a day
class Meal{

  int _mealID;
  String _imagePath;
  MealType _mealType;
  late String _comment;

  Meal(this._mealID,this._imagePath,this._mealType);

  int get id{
    return this._mealID;
  }

  String get image{
    return this._imagePath;
  }

  String get comment{
    return this._comment;
  }

  MealType get mealType{
    return this._mealType;
  }

  set comment(String newComment){
    this._comment = newComment;
  }

  void removeComment(){
    this._comment ="";
  }

}