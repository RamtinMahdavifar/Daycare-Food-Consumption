import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/institution.dart';

// run tests from the terminal using: flutter test test/institution_test.dart
void main(){
  group("institution getters and setters",() {
    test("institution getters", () {
      final testInstitution = Institution("test institution", "test address");
      expect(testInstitution.name, "test institution");
      expect(testInstitution.address, "test address");
    });

    test("institution setters", () {
      final testInstitution = Institution("test institution", "test address");
      testInstitution.name = "new test name";
      testInstitution.address = "new test address";
      expect(testInstitution.name, "new test name");
      expect(testInstitution.address, "new test address");
    });
  });

}