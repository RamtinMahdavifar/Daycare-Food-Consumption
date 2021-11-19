import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:plate_waste_recorder/Model/string_image_converter.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';

/// Class representing a Meal served to a particular subject
/// a subject can have multiple meals in a day and multiple meals throughout time
class Meal{
  //**** Meal Properties ********
  // all fields are declared late as our constructor doesn't take references to these
  // fields directly but instead takes separate variables which are validated before
  // being stored as our local fields, some fields like _mealID are generated locally
  // in our constructor instead of being passed in

  // Meal Id, unique ID for each meal
  late String _mealId;

  // status of the meal, denotes whether meal represents a just served, uneaten food
  // item, or food that has been served and not eaten etc
  late FoodStatus _mealStatus;

  // give each non-mandatory field a default value as we meals may not be provided
  // String representing the name of this particular meal
  late String _mealName;

  // this is the string representing
  // the image of the meal before being eaten by a subject
  late String _imageString;

  // double precision value recording the weight of the meal
  late double _mealWeight;

  // Comment associated with this particular meal, can be added to give additional
  // context or information about a meal
  late String _comment;


  //***** Meal constructor ********
  // only accept the mandatory fields for a meal here, all other fields are optional and
  // can be filled in later
  Meal(String mealName, FoodStatus mealStatus, String imageString, double mealWeight, String comment){
    // ensure our input fields are valid, here our comment field can be the empty string
    // if this particular meal doesn't have any comments
    assert(mealName.isNotEmpty);
    assert(imageString.isNotEmpty);
    assert(mealWeight>0.0);
    // meal cannot be have the view status, as we only store data for either freshly served
    // uneaten meals, leftover eaten meals or containers
    assert(mealStatus!=FoodStatus.view);
    this._mealName = mealName;
    this._mealStatus = mealStatus;
    this._imageString = imageString;
    this._mealWeight = mealWeight;
    this._comment = comment;
    // generate a unique ID for this meal using our firebase database
    this._mealId = Database().generateUniqueID();
  }




  //****** Meal getters **********

  /// returns true if this meal has a before image associated with it, ie if this._beforeImageAsString
  /// is not ""
  /// Preconditions: None
  /// Postconditions: returns true if this meal has a before image associated with it, ie if this._beforeImageAsString
  /// is not "", false otherwise
  bool mealHasBeforeImage(){
    return this._beforeImageAsString.isNotEmpty;
  }

  /// returns true if this meal has an after image associated with it, ie if this._afterImageAsString
  /// is not ""
  /// Preconditions: None
  /// Postconditions: returns true if this meal has an after image associated with it, ie if this._afterImageAsString
  /// is not "", false otherwise
  bool mealHasAfterImage(){
    return this._afterImageAsString.isNotEmpty;
  }

  /// returns true if this meal has a before weight associated with it, ie if this._beforeMealWeight
  /// has been previously set and is not a default place holder value
  /// Preconditions: None
  /// Postconditions: returns true if this meal has a before weight associated with it, ie if this._beforeMealWeight
  /// has been previously set and is not a default place holder value, returns false otherwise
  bool mealHasBeforeWeight(){
    // if the meal has some before weight other than the initial placeholder weight
    // we know a weight has been input for the meal
    return this._beforeMealWeight != this._INITIALPLACEHOLDERWEIGHT;
  }

  /// returns true if this meal has an after weight associated with it, ie if this._afterMealWeight
  /// has been previously set and is not a default place holder value
  /// Preconditions: None
  /// Postconditions: returns true if this meal has an after weight associated with it, ie if this._afterMealWeight
  /// has been previously set and is not a default place holder value, returns false otherwise
  bool mealHasAfterWeight(){
    // if the meal has some weight other than the initial placeholder weight we
    // know a weight has been input for the meal
    return this._afterMealWeight != this._INITIALPLACEHOLDERWEIGHT;
  }

  /// returns true if this meal has a comment associated with it, false otherwise
  /// Preconditions: None
  /// Postconditions: returns true if this meal has a comment associated with it, false otherwise
  bool mealHasComment(){
    return this._comment.isNotEmpty;
  }

  /// returns true if this meal has a comment associated with it, false otherwise
  /// Preconditions: None
  /// Postconditions: returns true if this meal has a comment associated with it, false otherwise
  bool mealHasName(){
    return this._mealName.isNotEmpty;
  }

  /// returns the filepath relative to the current directory that contains the meal's before
  /// image, the name of the image file specified by this filepath is composed as follows:
  /// this._mealId + "before.png"
  /// Preconditions: this.mealHasBeforeImage is true
  /// Postconditions: returns the relative filepath to an image file containing the
  /// meal's before image as described above
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

  /// returns the filepath relative to the current directory that contains the meal's after
  /// image, the name of the image file specified by this filepath is composed as follows:
  /// this._mealId + "after.png"
  /// Preconditions: this.mealHasAfterImage is true
  /// Postconditions: returns the relative filepath to an image file containing the
  /// meal's after image as described above
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

  String get mealName{
    assert(this.mealHasName());
    return this._mealName;
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

  /// sets the before image of the meal to the image at the path provided, this
  /// will overwrite any other before images if they exist for this meal
  /// Preconditions: newBeforeImagePath.isNotEmpty, newBeforeImagePath must be a valid
  /// image file type e.g. .png
  /// Postconditions: sets the before image of the meal to the image at the path provided, this
  /// will overwrite any other before images if they exist for this meal
  void set beforeImageAsString(String newBeforeImagePath){
    // ensure the provided image path is not an empty string
    assert(newBeforeImagePath.isNotEmpty);
    // convert the image at the specified path to a string, make this the new beforeImageString
    this._beforeImageAsString = convertImagePathToString(newBeforeImagePath);
  }

  /// sets the after image of the meal to the image at the path provided, this
  /// will overwrite any other after images if they exist for this meal
  /// Preconditions: newAfterImagePath.isNotEmpty, newAfterImagePath must be a valid
  /// image file type e.g. .png
  /// Postconditions: sets the after image of the meal to the image at the path provided, this
  /// will overwrite any other after images if they exist for this meal
  void set afterImageAsString(String newAfterImagePath){
    // ensure the provided image path is not an empty string
    assert(newAfterImagePath.isNotEmpty);
    // convert the image at the specified path to a string, make this the new afterImageString
    this._afterImageAsString = convertImagePathToString(newAfterImagePath);
  }

  /// sets the before weight of the meal to the double weight provided, the previous before
  /// weight is simply overwritten if such a weight is present
  /// Preconditions: newBeforeWeight>0.0
  /// Postconditions: sets the before weight of the meal to the double weight provided, the previous before
  /// weight is simply overwritten if such a weight is present
  void set beforeMealWeight(double newBeforeWeight){
    // ensure the weight provided is greater than 0.0, meals must have some weight
    assert(newBeforeWeight>0.0);
    this._beforeMealWeight = newBeforeWeight;
  }

  /// sets the after weight of the meal to the double weight provided, the previous after
  /// weight is simply overwritten if such a weight is present
  /// Preconditions: newAfterWeight>0.0
  /// Postconditions: the after weight of the meal is set to the double weight provided, the previous after
  /// weight is simply overwritten if such a weight is present
  void set afterMealWeight(double newAfterWeight){
    // ensure the weight provided is greater than 0.0, meals must have weight even
    // after being eaten as plates are still factored into weight
    assert(newAfterWeight>0.0);
    this._afterMealWeight = newAfterWeight;
  }

  /// sets the name of this meal to the string name provided, if the meal already has
  /// a name, this name is overwritten.
  /// Preconditions: newMealName.isNotEmpty
  /// Postconditions: the name of this meal is set to the input meal name, if the meal already has
  /// a name, this name is overwritten to the new value provided.
  void set mealName(String newMealName){
    // ensure the newly added meal name is not empty
    assert(newMealName.isNotEmpty);
    this._mealName = newMealName;
    Config.log.i("setting name of meal: " + this._mealId + " to: " + newMealName);
  }

  //****** Meal Custom methods *****

  //remove a comment
  void removeComment(){
    // regardless of whether we have a comment or not, simply set the comment
    // to an empty string to remove it
    this.comment = "";
    Config.log.i("removing comment from meal: " + this._mealId);
  }


  MealInfo getMealInfo(){
    // ensure this object has a valid ID before creating this info
    assert(this._mealId.isNotEmpty);
    return MealInfo(this._mealId, this._mealId);
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

  // @override
  Map<String, dynamic> toJson() => {
    '_mealName': this._mealName,
    '_mealID': this._mealId,
    '_comments': this._comment,
    '_beforeImageAsString': this._beforeImageAsString,
    '_afterImageAsString': this._afterImageAsString,
    '_beforeMealWeight': this._beforeMealWeight,
    '_afterMealWeight': this._afterMealWeight,
    '_mealType':this._mealType.toString()
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