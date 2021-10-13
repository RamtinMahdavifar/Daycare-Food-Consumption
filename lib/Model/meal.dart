
enum MealType{
  before,
  after
}

/// Class representing a Meal, which the food east by a subject
/// a subject can have multiple meals in a day
class Meal{
  //**** Meal Properties ********

  //Meal Id, unique ID for each meal
  int _mealId;

  //Meal image path, currently image is stored as string later this may change
  //depending upon how we decide to store images
  String _imagePath;

  //Meal type its and enum from Meal class which has value before and after
  MealType _mealType;

  //Meal comment each meal can have a comment
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