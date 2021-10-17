import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';
import 'package:test/test.dart';

void main(){
  group("meal info getters and setters",(){
    test("getters", (){
      final MealInfo testMealInfo = MealInfo("test ID", "test name");
      expect(testMealInfo.mealId, "test ID");
    });
  });

  group("meal info operators",(){
    test("== operator",(){
      final MealInfo testMealInfo = MealInfo("test ID", "test name");

      // test equality vs other objects
      expect(testMealInfo == "test", false);
      expect(testMealInfo == "", false);
      expect(testMealInfo == null, false);
      expect(testMealInfo == Meal("test ID"), false);

      // test equality vs MealInfo objects
      expect(testMealInfo == MealInfo("something", "name"), false);
      expect(testMealInfo == MealInfo("other ID", "test name"), false);
      expect(testMealInfo == MealInfo("test ID", "other name"), false);
      expect(testMealInfo == MealInfo("test ID", "test name"), true);
      MealInfo otherMealInfo = testMealInfo;
      expect(testMealInfo == otherMealInfo, true);
      expect(testMealInfo == testMealInfo, true);
    });
  });

  group("json operations",(){
    test("to json",(){
      final MealInfo testMealInfo = MealInfo("test ID", "test name");
      expect(testMealInfo.toJson(), <String, dynamic>{"mealId":"test ID", "databaseKey":"test ID", "name":"test name"});
    });

    test("from json",(){
      final Map<String,dynamic> testJSON = {"mealId":"test ID", "databaseKey":"test ID", "name":"test name"};
      expect(MealInfo.fromJSON(testJSON), MealInfo("test ID", "test name"));
    });
  });
}