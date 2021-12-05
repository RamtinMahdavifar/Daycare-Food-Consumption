import 'package:plate_waste_recorder/Model/researcher.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:test/test.dart';

// run tests from the terminal using: flutter test test/researcher_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/researcher_test.dart
void main() {
  group("researcher getters and setters", () {
    test("researcher getters", () {
      Researcher testResearcher = Researcher("test researcher");
      expect(testResearcher.getResearcherInfo(),
          ResearcherInfo("test researcher"));
    });
  });

  group("researcher json operations", () {
    test("researcher toJSON", () {
      final Researcher testResearcher = Researcher("test researcher");
      expect(testResearcher.toJson(), <String, dynamic>{
        "_researcherName": "test researcher",
        "_researchGroupInfos": "[]"
      });
      // TODO: add additional test cases once functionality to add ResearchGroups is added
    });
  });
}
