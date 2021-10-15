import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/subject.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/meal_info.dart';

// run tests from the terminal using: flutter test test/subject_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/subject_test.dart
void main(){
  group("subject getters and setters",(){
    test("subject getters",(){
      Subject testSubject = Subject("id1");
      expect(testSubject.id,"id1");
      expect(testSubject.subjectHasMeals(),false);
      expect(testSubject.subjectHasMealsForDate("2021-10-30"), false);
      expect(testSubject.getSubjectInfo(), SubjectInfo("id1"));
      // test removing a meal from this subject when the subject doesn't have meals
      testSubject.removeMeal(Meal("test meal ID"));
      expect(testSubject.subjectHasMeals(), false);
    });

    test("subject meal operations",(){
      Subject testSubject = Subject("lab rat");
      testSubject.addSubjectMealForDate(DateTime(2021,10,5), Meal("test meal"));

      expect(testSubject.subjectHasMeals(),true);
      expect(testSubject.getSubjectMealDates(),<String>["2021-10-05"]);
      expect(testSubject.subjectHasMealsForDate("2021-10-05"),true);
      expect(testSubject.getSubjectMealsForDate("2021-10-05"),<MealInfo>[MealInfo("test meal", "test meal")]);

      testSubject.addSubjectMealForDate(DateTime(2021,6,22), Meal("other meal"));
      expect(testSubject.subjectHasMeals(),true);
      expect(testSubject.getSubjectMealDates(),<String>["2021-10-05", "2021-06-22"]);
      expect(testSubject.subjectHasMealsForDate("2021-10-05"),true);
      expect(testSubject.subjectHasMealsForDate("2021-06-22"),true);
      expect(testSubject.getSubjectMealsForDate("2021-06-22"),<MealInfo>[MealInfo("other meal", "other meal")]);

      testSubject.addSubjectMealForDate(DateTime(2021,10,5), Meal("second meal for day"));
      expect(testSubject.getSubjectMealDates(),<String>["2021-10-05", "2021-06-22"]);
      expect(testSubject.subjectHasMealsForDate("2021-10-05"),true);
      expect(testSubject.subjectHasMealsForDate("2021-06-22"),true);
      expect(testSubject.getSubjectMealsForDate("2021-10-05"),<MealInfo>[MealInfo("test meal", "test meal"),
        MealInfo("second meal for day", "second meal for day")]);
    });
  });
  // TODO: include tests for JSON operations and == operator once methods are updated


}