import 'package:mockito/mockito.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';

class SubjectInfoMock extends Mock implements SubjectInfo{

  @override
  String get subjectId{
    return "ID 123";
  }
}