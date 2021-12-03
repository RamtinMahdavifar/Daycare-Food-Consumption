import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:plate_waste_recorder/Model/string_image_converter.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Helper/date_converter.dart';

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

  // String representation of the date the data for this particular meal was captured
  late String _mealDate;


  //***** Meal constructor ********
  // this constructor specifically is for situations where we want a completely new meal
  // this meal generate it's own new unique ID to be used by default
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
    // this newly created meal will have the current day's date as it's mealDate
    // as data for this meal has been captured on this day
    this._mealDate = convertDateToString(DateTime.now());
  }

  // specify an additional constructor that allows us to specify a particular meal ID
  // to use for this new meal, this should only be used when we want to create a new meal
  // to represent a different status of an existing meal, the input ID should be the ID
  // of that already existing meal
  Meal.fromExistingID(String mealName, FoodStatus mealStatus, String imageString, double mealWeight, String comment, String ID){
    // ensure our input fields are valid, here our comment field can be the empty string
    // if this particular meal doesn't have any comments
    assert(mealName.isNotEmpty);
    assert(imageString.isNotEmpty);
    assert(mealWeight>0.0);
    assert(ID.isNotEmpty);
    // meal cannot be have the view status, as we only store data for either freshly served
    // uneaten meals, leftover eaten meals or containers
    assert(mealStatus!=FoodStatus.view);
    this._mealName = mealName;
    this._mealStatus = mealStatus;
    this._imageString = imageString;
    this._mealWeight = mealWeight;
    this._comment = comment;
    // instead of generating a unique ID as we usually do, use the input ID
    this._mealId = ID;
    // this newly created meal will have the current day's date as it's mealDate
    // as data for this meal has been captured on this day
    this._mealDate = convertDateToString(DateTime.now());
  }




  //****** Meal getters **********

  /// returns true if this meal has a comment associated with it, false otherwise
  /// Preconditions: None
  /// Postconditions: returns true if this meal has a comment associated with it, false otherwise
  bool mealHasComment(){
    return this._comment.isNotEmpty;
  }


  /// returns the filepath relative to the current directory that contains the meal's
  /// image, the name of the image file specified by this filepath is composed as follows:
  /// this._mealId + ".png"
  /// Preconditions: None
  /// Postconditions: returns the relative filepath to an image file containing the
  /// meal's image as described above
  String getBImageFilePath(){

    // create a filename to export our string before image to, note that this is a before
    // image
    // TODO: see how meal ids work as image file names, may need something more readable
    // TODO: may need to change image formats depending on what format phones use
    String newImageFileName = this._mealId + ".png";
    // convert our string before image to an image file
    convertStringToImage(this._imageString, newImageFileName);
    return newImageFileName;
  }

  //Meal Id
  String get id{
    return this._mealId;
  }

  String get mealName{
    return this._mealName;
  }

  //meal comment
  String get comment{
    // ensure our meal actually has a comment
    assert(this.mealHasComment());
    return this._comment;
  }

  //meal type
  FoodStatus get mealStatus{
    return this._mealStatus;
  }

  //***** Meal setters ******

  //Set Meal comments
  set comment(String newComment){
    // ensure the provided comment is not empty
    assert(newComment.isNotEmpty);
    this._comment = newComment;
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
    // ensure this object has a valid ID and name before creating this info
    assert(this._mealId.isNotEmpty);
    assert(this._mealName.isNotEmpty);
    return MealInfo(this._mealId, this._mealName, this._mealStatus);
  }




  // TODO: overwrite hashcode(), two equal objects should have the same hashcode
  @override
  bool operator ==(Object other){
    if (other.runtimeType == this.runtimeType){
      // if other is of type meal, compare fields of both meals
      Meal otherMeal = other as Meal;
      return this._mealId == otherMeal._mealId &&
          this._imageString == otherMeal._imageString &&
          this._mealStatus == otherMeal._mealStatus &&
          this._mealName == otherMeal._mealName &&
          this._mealWeight == otherMeal._mealWeight &&
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
    '_imageAsString': this._imageString,
    '_mealStatus': this._mealStatus.toString(),
    '_mealWeight': this._mealWeight,
    '_mealDate': this._mealDate,
  };


  Meal.fromJSON(Map<String, dynamic> json) // TODO: watch out for empty strings or JSON fields, may cause problems
      : _mealName = json['_mealName'].toString(),
        _mealId = json['_mealId'].toString(),
        _comment = json['_comments'].toString(),
        _imageString = json['_imageString'].toString(),
        _mealStatus = json['_mealStatus'] as FoodStatus,
        _mealWeight = json['_mealWeight'] as double,
        _mealDate = json['_mealDate'].toString();
}