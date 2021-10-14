import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:plate_waste_recorder/Model/string_image_converter.dart';


enum MealType{
  before,
  after
}

/// Class representing a Meal served to a particular subject
/// a subject can have multiple meals in a day and multiple meals throughout time
class Meal{
  //**** Meal Properties ********

  //Meal Id, unique ID for each meal
  String _mealId;

  // String representing the name of this particular meal
  String _mealName;

  // give each non-mandatory field a default value as we meals may not be provided
  // images, weights, comments etc

  // Images are converted to strings when stored, this is the string representing
  // the image of the meal before being eaten by a subject
  String _beforeImageAsString = "";

  // String representing the image of the meal after being eaten by the subject
  String _afterImageAsString = "";


  //Meal type its and enum from Meal class which has value before and after
  MealType _mealType = MealType.before;

  // define a constant initial placeholder weight that the weight fields are given
  // before having been initialized
  final double _INITIALPLACEHOLDERWEIGHT = -1.0;


  // double precision value recording the weight of the meal before being eaten
  double _beforeMealWeight = -1.0;

  // double precision value recording the weight of the meal after being eaten
  double _afterMealWeight = -1.0;

  // Comment associated with this particular meal, can be added to give additional
  // context or information about a meal
  String _comment = "";


  //***** Meal constructor ********
  // only accept the mandatory fields for a meal here, all other fields are optional and
  // can be filled in later
  Meal(this._mealName, this._mealId);




  //****** Meal getters **********

  bool mealHasBeforeImage(){
    return this._beforeImageAsString.isNotEmpty;
  }

  bool mealHasAfterImage(){
    return this._afterImageAsString.isNotEmpty;
  }

  bool mealHasBeforeWeight(){
    // if the meal has some before weight other than the initial placeholder weight
    // we know a weight has been input for the meal
    return this._beforeMealWeight != this._INITIALPLACEHOLDERWEIGHT;
  }

  bool mealHasAfterWeight(){
    // if the meal has some weight other than the initial placeholder weight we
    // know a weight has been input for the meal
    return this._afterMealWeight != this._INITIALPLACEHOLDERWEIGHT;
  }

  bool mealHasComment(){
    return this._comment.isNotEmpty;
  }

  String getBeforeImageFilePath(){
    // ensure we have a before image
    assert(this.mealHasBeforeImage());

    // create a filename to export our string before image to, note that this is a before
    // image
    // TODO: see how meal ids work as image file names, may need something more readable
    // TODO: may need to change image formats depending on what format phones use
    String newBeforeImageFileName = this._mealId + "before.png";
    // convert our string before image to an image file
    convertStringToImage(this._beforeImageAsString, newBeforeImageFileName);
    return newBeforeImageFileName;
  }

  String getAfterImageFilePath(){
    // ensure this meal has an after image
    assert(this.mealHasAfterImage());

    // create a file name to export our string after image to, include that this
    // is an after image of this meal
    String newAfterImageFileName = this._mealId + "after.png";
    // convert our string after image to an image file
    convertStringToImage(this._beforeImageAsString, newAfterImageFileName);
    return newAfterImageFileName;
  }

  //Meal Id
  String get id{
    return this._mealId;
  }

  //meal comment
  String get comment{
    // ensure our meal actually has a comment
    assert(this.mealHasComment());
    return this._comment;
  }

  //meal type
  MealType get mealType{
    return this._mealType;
  }

  //***** Meal setters ******

  //Set Meal comments
  set comment(String newComment){
    // ensure the provided comment is not empty
    assert(newComment.isNotEmpty);
    this._comment = newComment;
  }

  // sets the before image of the meal to the image at the path provided, this
  // will overwrite any other before images if they exist
  void set beforeImageAsString(String newBeforeImagePath){
    // ensure the provided image path is not an empty string
    assert(newBeforeImagePath.isNotEmpty);
    // convert the image at the specified path to a string, make this the new beforeImageString
    this._beforeImageAsString = convertImageToString(newBeforeImagePath);
  }

  // sets the after image of the meal to the image at the path provided, this
  // will overwrite any other after images if they exist
  void set afterImageAsString(String newAfterImagePath){
    // ensure the provided image path is not an empty string
    assert(newAfterImagePath.isNotEmpty);
    // convert the image at the specified path to a string, make this the new afterImageString
    this._afterImageAsString = convertImageToString(newAfterImagePath);
  }

  // sets the before weight of the meal to the double weight provided, the previous before
  // weight is simply overwritten if such a weight is present
  void set beforeMealWeight(double newBeforeWeight){
    // ensure the weight provided is greater than 0.0, meals must have some weight
    assert(newBeforeWeight>0.0);
    this._beforeMealWeight = newBeforeWeight;
  }

  // sets the weight of the meal after it has been eaten or consumed, if the meal
  // already has an after weight, it is overwritten by the new weight provided
  void set afterMealWeight(double newAfterWeight){
    // ensure the weight provided is greater than 0.0, meals must have weight even
    // after being eaten as plates are still factored into weight
    assert(newAfterWeight>0.0);
    this._afterMealWeight = newAfterWeight;
  }

  //****** Meal Custom methods *****

  //remove a comment
  void removeComment(){
    // regardless of whether we have a comment or not, simply set the comment
    // to an empty string to remove it
    this.comment = "";
  }


  MealInfo getMealInfo(){
    return MealInfo(this._mealId, this._mealName);
  }




  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      // if other is of type meal, compare fields of both meals
      Meal otherMeal = other as Meal;
      return this._mealId == otherMeal._mealId &&
          this._beforeImageAsString == otherMeal._beforeImageAsString &&
          this._afterImageAsString == otherMeal._afterImageAsString &&
          this._mealName == otherMeal._mealName &&
          this._beforeMealWeight == otherMeal._beforeMealWeight &&
          this._afterMealWeight == otherMeal._afterMealWeight &&
          this._mealType == otherMeal._mealType &&
          this._comment == otherMeal._comment;
    }
    // other object isn't of type Meal, cannot be equal
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    '_mealName': this._mealName,
    '_mealID': this._mealId,
    '_comments': this._comment,
    '_beforeImageAsString': this._beforeImageAsString,
    '_afterImageAsString': this._afterImageAsString,
    '_beforeMealWeight': this._beforeMealWeight,
    '_afterMealWeight': this._afterMealWeight,
    '_mealType':this._mealType
  };


  Meal.fromJSON(Map<String, dynamic> json) // TODO: watch out for empty strings or JSON fields, may cause problems
      : _mealName = json['_mealName'].toString(),
        _mealId = json['_mealId'].toString(),
        _comment = json['_comments'].toString(),
        _beforeImageAsString = json['_beforeImageAsString'].toString(),
        _afterImageAsString = json['_afterImageAsString'].toString(),
        _beforeMealWeight = json['_beforeMealWeight'] as double,
        _afterMealWeight = json['_afterMealWeight'] as double,
        _mealType = json['mealType'] as MealType;
}