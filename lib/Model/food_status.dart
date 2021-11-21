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