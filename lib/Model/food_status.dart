/// define an enum used to list possible states a food/meal can be in currently we have the
/// states uneaten: for food that has just been served and not yet eaten,
/// eaten: for food that has been served and then eaten by a subject, this is
/// leftover food not finished
/// container: for underlying containers used to house the meal or other artifacts like wrappers, inedible
/// portions of food like peels
/// view: this particular status is used when we don't want to record any data for a meal
/// but instead want to view that meal and see it's data
enum FoodStatus{
  uneaten,
  eaten,
  container,
  view
}

/// Converts the input string foodStatus to a FoodStatus enum
/// Preconditions: foodStatus must be a string representation of a FoodStatus enum
/// ie foodStatus must be the result of calling .toString() on a particular FoodStatus
/// enum and must have the form "FoodStatus.eaten" or "FoodStatus.container" and so on
/// if this precondition is not met, an exception is thrown
/// Postcondtions: a FoodStatus enum with a corresponding state to the input string foodStatus
/// is returned, for example if "FoodStatus.uneaten" is input a FoodStatus enum with value
/// FoodStatus.uneaten is returned
FoodStatus parseFoodStatus(String foodStatus){
  switch(foodStatus){
    case "FoodStatus.uneaten": return FoodStatus.uneaten;
    case "FoodStatus.eaten": return FoodStatus.eaten;
    case "FoodStatus.container": return FoodStatus.container;
    case "FoodStatus.view": return FoodStatus.view;
    default: throw Exception("cannot convert string $foodStatus to a FoodStatus enum");
  }
}