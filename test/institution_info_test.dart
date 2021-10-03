import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';

// run tests from the terminal using: flutter test test/institution_info_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/institution_info_test.dart
void main(){
  group("institution info getters and setters", (){
    test("getters", (){
      final InstitutionInfo testInstitutionInfo = InstitutionInfo("test institution", "test address");
      expect(testInstitutionInfo.institutionAddress, "test address");
    });
  });

  group("institution info operators",(){
    // consider toString an operator as it's so fundamental
    test("toString",(){
      final InstitutionInfo testInstitutionInfo = InstitutionInfo("test institution", "test address");
      expect(testInstitutionInfo.toString(), "test institution");
    });

    test("== operator",(){
      final InstitutionInfo testInstitutionInfo = InstitutionInfo("test institution", "test address");

      // test equality vs other objects
      expect(testInstitutionInfo == "test", false);
      expect(testInstitutionInfo == "", false);
      expect(testInstitutionInfo == null, false);
      expect(testInstitutionInfo == Institution("test institution", "test address"), false);

      // test equality vs InstitutionInfo objects
      expect(testInstitutionInfo == InstitutionInfo("something", "else"), false);
      expect(testInstitutionInfo == InstitutionInfo("test address", "test institution"), false);
      expect(testInstitutionInfo == InstitutionInfo("test address", "test address"), false);
      expect(testInstitutionInfo == InstitutionInfo("test institution", "test institution"), false);
      expect(testInstitutionInfo == InstitutionInfo("test institution", "test address"), true);
      InstitutionInfo otherInstitution = testInstitutionInfo;
      expect(testInstitutionInfo == otherInstitution, true);
      expect(testInstitutionInfo == testInstitutionInfo, true);
    });
  });

  group("json operations",(){
    test("to json",(){
      final InstitutionInfo testInstitutionInfo = InstitutionInfo("test institution", "test address");
      expect(testInstitutionInfo.toJson(), <String, dynamic>{"name":"test institution", "databaseKey":"test address",
        "_institutionAddress":"test address"});

      testInstitutionInfo.name = "";

      expect(testInstitutionInfo.toJson(), <String, dynamic>{"name":"", "databaseKey":"test address",
        "_institutionAddress":"test address"});
    });

    test("from json",(){
      final Map<String,dynamic> testJSON = {"name":"test institution", "databaseKey":"test address",
        "_institutionAddress":"test address"};

      expect(InstitutionInfo.fromJSON(testJSON), InstitutionInfo("test institution", "test address"));

      testJSON["name"] = "";
      testJSON["databaseKey"] = "";
      testJSON["_institutionAddress"] = "";

      expect(InstitutionInfo.fromJSON(testJSON), InstitutionInfo("", ""));
    });
  });

}