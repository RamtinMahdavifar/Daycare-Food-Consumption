import 'package:plate_waste_recorder/Model/food_status.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:test/test.dart';

void main(){
  group("meal info getters and setters",(){
    test("getters", (){
      final MealInfo testMealInfo = MealInfo("test ID", "test name", FoodStatus.uneaten);
      expect(testMealInfo.mealId, "test ID");
      expect(testMealInfo.mealStatus, FoodStatus.uneaten);
      expect(testMealInfo.name, "test name");
    });
  });

  group("meal info operators",(){
    test("== operator",(){
      final MealInfo testMealInfo = MealInfo("test ID", "test name", FoodStatus.uneaten);

      // test equality vs other objects
      expect(testMealInfo == "test", false);
      expect(testMealInfo == "", false);
      expect(testMealInfo == null, false);
      expect(testMealInfo == "test value", false);

      // test equality vs MealInfo objects
      expect(testMealInfo == MealInfo("something", "name", FoodStatus.uneaten), false);
      expect(testMealInfo == MealInfo("other ID", "test name", FoodStatus.uneaten), false);
      expect(testMealInfo == MealInfo("test ID", "other name", FoodStatus.uneaten), false);
      expect(testMealInfo == MealInfo("test ID", "test name", FoodStatus.eaten), false);
      expect(testMealInfo == MealInfo("test ID", "test name", FoodStatus.container), false);
      expect(testMealInfo == MealInfo("test ID", "test name", FoodStatus.uneaten), true);
      MealInfo otherMealInfo = testMealInfo;
      expect(testMealInfo == otherMealInfo, true);
      expect(testMealInfo == testMealInfo, true);
    });
  });

  group("json operations",(){
    test("to json",(){
      final MealInfo testMealInfo = MealInfo("test ID", "test name", FoodStatus.uneaten);
      expect(testMealInfo.toJson(), <String, dynamic>{"_mealId":"test ID", "databaseKey":"test ID", "name":"test name", "_mealStatus": "FoodStatus.uneaten"});
    });

    test("from json",(){
      final Map<String,dynamic> testJSON = {"_mealId":"test ID", "databaseKey":"test ID", "name":"test name", "_mealStatus": "FoodStatus.uneaten"};
      expect(MealInfo.fromJSON(testJSON), MealInfo("test ID", "test name", FoodStatus.uneaten));
    });
  });
}