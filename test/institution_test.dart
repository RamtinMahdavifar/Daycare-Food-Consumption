import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';

// run tests from the terminal using: flutter test test/institution_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/institution_test.dart
void main(){
  group("institution getters and setters",() {
    test("institution getters", () {
      final Institution testInstitution = Institution("test institution", "test address");
      expect(testInstitution.name, "test institution");
      expect(testInstitution.address, "test address");

      final InstitutionInfo testInstitutionInfo = InstitutionInfo("test institution", "test address");
      expect(testInstitution.getInstitutionInfo(), testInstitutionInfo);
    });

    test("institution setters", () {
      final Institution testInstitution = Institution("test institution", "test address");
      testInstitution.name = "new test name";
      testInstitution.address = "new test address";
      expect(testInstitution.name, "new test name");
      expect(testInstitution.address, "new test address");
    });
  });

  group("institution operators", (){
    test("== operator", (){
      final Institution testInstitution = Institution("test institution", "test address");

      // test equality vs other objects
      expect(testInstitution == "test", false);
      expect(testInstitution == "", false);
      expect(testInstitution == null, false);
      expect(testInstitution == InstitutionInfo("test institution", "test address"), false);

      // test equality vs Institution objects
      expect(testInstitution == Institution("something", "else"), false);
      expect(testInstitution == Institution("test address", "test institution"), false);
      expect(testInstitution == Institution("test address", "test address"), false);
      expect(testInstitution == Institution("test institution", "test institution"), false);
      expect(testInstitution == Institution("test institution", "test address"), true);
      Institution otherInstitution = testInstitution;
      expect(testInstitution == otherInstitution, true);
      expect(testInstitution == testInstitution, true);
    });

  });

  group("institution json", (){
    test("to json",(){
      final Institution testInstitution = Institution("test institution", "test address");
      expect(testInstitution.toJson(), <String, dynamic>{"_name":"test institution", "_address":"test address"});

      testInstitution.name = "";
      testInstitution.address = "";

      expect(testInstitution.toJson(), <String, dynamic>{"_name":"", "_address":""});
    });

    test("from json",(){
      final Map<String,dynamic> testJSON = {"_name":"test institution", "_address":"test address"};

      expect(Institution.fromJSON(testJSON), Institution("test institution", "test address"));

      testJSON["_name"] = "";
      testJSON["_address"] = "";

      expect(Institution.fromJSON(testJSON), Institution("", ""));
    });
  });



}