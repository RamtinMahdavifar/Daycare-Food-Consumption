import 'package:plate_waste_recorder/Model/database.dart';
import 'package:test/test.dart';

// run tests from the terminal using: flutter test test/database_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/database_test.dart
void main() {
  group("database initialization", () {
    test("database instance is non-null", () {
      final databaseInstance = Database();
      expect(databaseInstance == null, false);
    });

    test("two database instances are identical", () {
      final firstDatabaseInstance = Database();
      final secondDatabaseInstance = Database();
      expect(identical(firstDatabaseInstance, secondDatabaseInstance), true);
    });
  });
}
