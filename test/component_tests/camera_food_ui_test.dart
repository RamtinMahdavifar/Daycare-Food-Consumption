import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/food_capture.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import '../mocks/institution_info_mock.dart';
import '../mocks/subject_info_mock.dart';


void main() {
  group("Capture Food Tests",() {

    final InstitutionInfoMock currentInstitutionMock = InstitutionInfoMock();
    final SubjectInfoMock subjectInfoMock = SubjectInfoMock();

    testWidgets('capture food item page tests', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: FoodCapture(currentInstitutionMock, subjectInfoMock, FoodStatus.eaten),
      ));
      Config.log.i("Component Testing - capture food item page tests");

      final cameraFoodEatenHeader = find.text("Capture Eaten Food Item");

      Config.log.i("Scan Student ID page header is present");
      expect(cameraFoodEatenHeader, findsOneWidget);
    });
  });
}
