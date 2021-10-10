import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/meal.dart';

// run tests from the terminal using: flutter test test/meal_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/meal_test.dart
void main(){
  group("Meal getters and setters",(){
    test("Meal getters",(){

      Meal testMeal = Meal(1,"test image 1",MealType.before);


      expect(testMeal.id,1);
      expect(testMeal.image,"test image 1");
      expect(testMeal.mealType,MealType.before);
      testMeal.comment = "Test comment";
      expect(testMeal.comment,"Test comment");


    });
    test("Add Meal comments",(){
      Meal testMeal = Meal(1,"test image 1",MealType.before);

      testMeal.comment = "Test comment 2";
      expect(testMeal.comment,"Test comment 2");


    });

    test("Remove Meal comments",(){
      Meal testMeal = Meal(1,"test image 1",MealType.before);

      testMeal.comment = "Test comment 3";
      expect(testMeal.comment,"Test comment 3");

      testMeal.removeComment();

      expect(testMeal.comment,"");

    });
  });


}