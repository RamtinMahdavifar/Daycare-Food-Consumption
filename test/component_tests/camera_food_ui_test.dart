import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/food_capture.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';

class InstitutionInfoMock extends Mock implements InstitutionInfo{

  @override
  String get institutionAddress{
    return "hihihihi";
  }
}

class SubjectInfoMock extends Mock implements SubjectInfo{

  @override
  String get subjectId{
    return "hi";
  }
}

void main() {
  group("Capture Food Tests",() {

    final InstitutionInfoMock currentInstitutionMock = InstitutionInfoMock();
    final SubjectInfoMock subjectInfoMock = SubjectInfoMock();

    testWidgets('capture food item page tests', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: FoodCapture(currentInstitutionMock, subjectInfoMock, FoodStatus.eaten ),
      ));
      Config.log.i("Component Testing - capture food item page tests");

      final cameraFoodEatenHeader = find.text("Capture Eaten Food Item");

      Config.log.i("Scan Student ID page header is present");
      expect(cameraFoodEatenHeader, findsOneWidget);
    });
  });
}
