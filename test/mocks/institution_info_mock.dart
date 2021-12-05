import 'package:mockito/mockito.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';

class InstitutionInfoMock extends Mock implements InstitutionInfo{

  @override
  String get institutionAddress{
    return "Campus Drive";
  }
}