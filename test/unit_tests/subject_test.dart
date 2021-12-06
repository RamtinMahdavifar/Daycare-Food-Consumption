import 'package:plate_waste_recorder/Model/subject.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:test/test.dart';

// run tests from the terminal using: flutter test test/subject_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/subject_test.dart
void main() {
  group("subject getters and setters", () {
    test("subject getters", () {
      Subject testSubject = Subject("id1");
<<<<<<< HEAD
      expect(testSubject.id,"id1");
      expect(testSubject.getSubjectInfo(), SubjectInfo("id1"));
    });
  });
}
=======
      expect(testSubject.id, "id1");
      expect(testSubject.getSubjectInfo(), SubjectInfo("id1"));
    });
  });
}
>>>>>>> 4ab98938fb2a20d874ba663ac66e699f70aaa758
