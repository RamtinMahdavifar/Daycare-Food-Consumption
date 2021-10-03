import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

// run tests from the terminal using: flutter test test/research_group_info_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/research_group_info_test.dart
void main(){
  group("researcher info operators",(){
    test("toString",(){
      ResearchGroupInfo testResearchGroupInfo = ResearchGroupInfo("test research group");
      expect(testResearchGroupInfo.toString(),"test research group");
      testResearchGroupInfo = ResearchGroupInfo("");
      expect(testResearchGroupInfo.toString(),"");
    });
    test("== operator",(){
      ResearchGroupInfo testResearchGroupInfo = ResearchGroupInfo("test research group");

      // test equality vs other objects
      expect(testResearchGroupInfo == "test", false);
      expect(testResearchGroupInfo == "", false);
      expect(testResearchGroupInfo == null, false);
      expect(testResearchGroupInfo == ResearcherInfo("test research group"), false);

      // test equality vs ResearcherInfo objects
      expect(testResearchGroupInfo == ResearchGroupInfo("something"), false);
      expect(testResearchGroupInfo == ResearchGroupInfo("test name"), false);
      expect(testResearchGroupInfo == ResearchGroupInfo("researcher"), false);
      expect(testResearchGroupInfo == ResearchGroupInfo(""), false);
      expect(testResearchGroupInfo == ResearchGroupInfo("test research group"), true);
      ResearchGroupInfo otherResearchGroup = testResearchGroupInfo;
      expect(testResearchGroupInfo == otherResearchGroup, true);
      expect(testResearchGroupInfo == testResearchGroupInfo, true);
    });
  });

  group("json operations",(){
    test("toJSON",(){
      final ResearchGroupInfo testResearchGroupInfo = ResearchGroupInfo("test research group");
      expect(testResearchGroupInfo.toJson(), <String, dynamic>{"name":"test research group", "databaseKey":"test research group"});
    });

    test("fromJSON",(){
      final Map<String,dynamic> testJSON = {"name":"test research group", "databaseKey":"test research group"};

      expect(ResearchGroupInfo.fromJSON(testJSON), ResearchGroupInfo("test research group"));

      testJSON["name"] = "";
      testJSON["databaseKey"] = "";

      expect(ResearchGroupInfo.fromJSON(testJSON), ResearchGroupInfo(""));
    });
  });

}