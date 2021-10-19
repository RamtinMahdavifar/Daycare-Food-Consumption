import 'package:plate_waste_recorder/Model/researcher.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:test/test.dart';

// run tests from the terminal using: flutter test test/researcher_info_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/researcher_info_test.dart
void main(){
  group("researcher info operators",(){
    test("toString",(){
      ResearcherInfo testResearcherInfo = ResearcherInfo("test researcher");
      expect(testResearcherInfo.toString(),"test researcher");
    });
    test("== operator",(){
      ResearcherInfo testResearcherInfo = ResearcherInfo("test researcher");

      // test equality vs other objects
      expect(testResearcherInfo == "test", false);
      expect(testResearcherInfo == "", false);
      expect(testResearcherInfo == null, false);
      expect(testResearcherInfo == Researcher("test researcher"), false);

      // test equality vs ResearcherInfo objects
      expect(testResearcherInfo == ResearcherInfo("something"), false);
      expect(testResearcherInfo == ResearcherInfo("test name"), false);
      expect(testResearcherInfo == ResearcherInfo("researcher"), false);
      expect(testResearcherInfo == ResearcherInfo("test researcher"), true);
      ResearcherInfo otherResearcher = testResearcherInfo;
      expect(testResearcherInfo == otherResearcher, true);
      expect(testResearcherInfo == testResearcherInfo, true);
    });
  });

  group("json operations",(){
    test("toJSON",(){
      final ResearcherInfo testResearcherInfo = ResearcherInfo("test researcher");
      expect(testResearcherInfo.toJson(), <String, dynamic>{"name":"test researcher", "databaseKey":"test researcher"});
    });

    test("fromJSON",(){
      final Map<String,dynamic> testJSON = {"name":"test researcher", "databaseKey":"test researcher"};

      expect(ResearcherInfo.fromJSON(testJSON), ResearcherInfo("test researcher"));
    });
  });

}