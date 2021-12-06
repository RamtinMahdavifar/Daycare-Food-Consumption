import 'package:plate_waste_recorder/Model/subject.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:test/test.dart';

void main() {
  group("subject info getters and setters", () {
    test("getters", () {
      final SubjectInfo testSubjectInfo = SubjectInfo("test ID");
      expect(testSubjectInfo.subjectId, "test ID");
    });
  });

  group("subject info operators", () {
    test("== operator", () {
      final SubjectInfo testSubjectInfo = SubjectInfo("test ID");

      // test equality vs other objects
      expect(testSubjectInfo == "test", false);
      expect(testSubjectInfo == "", false);
      expect(testSubjectInfo == null, false);
      expect(testSubjectInfo == Subject("test ID"), false);

      // test equality vs SubjectInfo objects
      expect(testSubjectInfo == SubjectInfo("something"), false);
      expect(testSubjectInfo == SubjectInfo("other ID"), false);
      expect(testSubjectInfo == SubjectInfo("test Id"), false);
      expect(testSubjectInfo == SubjectInfo("test ID"), true);
      SubjectInfo otherSubject = testSubjectInfo;
      expect(testSubjectInfo == otherSubject, true);
      expect(testSubjectInfo == testSubjectInfo, true);
    });
  });

  group("json operations", () {
    test("to json", () {
      final SubjectInfo testSubjectInfo = SubjectInfo("test ID");
      expect(testSubjectInfo.toJson(),
          <String, dynamic>{"subjectId": "test ID", "databaseKey": "test ID"});
    });

    test("from json", () {
      final Map<String, dynamic> testJSON = {
        "subjectId": "test ID",
        "databaseKey": "test ID"
      };

      expect(SubjectInfo.fromJSON(testJSON), SubjectInfo("test ID"));
    });
  });
}
