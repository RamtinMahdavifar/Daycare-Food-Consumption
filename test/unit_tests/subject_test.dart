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
      expect(testSubject.getSubjectInfo(), SubjectInfo("id1"));
    });
  });
}