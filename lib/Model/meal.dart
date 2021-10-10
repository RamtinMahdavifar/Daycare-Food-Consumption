
enum MealType{
  before,
  after
}

/// Class representing a Meal, which the food east by a subject
/// a subject can have multiple meals in a day
class Meal{
  //**** Meal Properties ********

  //Meal Id, unique ID for each meal
  int _mealID;

  //Meal image path, currently image is stored as string later this may change
  //depending upon how we decide to store images
  String _imagePath;

  //Meal type its and enum from Meal class which has value before and after
  MealType _mealType;

  //Meal comment each meal can have a comment
  late String _comment;


  //***** Meal constructor ********
  Meal(this._mealID,this._imagePath,this._mealType);


  //****** Meal getters **********

  //Meal Id
  int get id{
    return this._mealID;
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

}