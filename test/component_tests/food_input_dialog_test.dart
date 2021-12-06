import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/food_input_dialog.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';

import '../mocks/institution_info_mock.dart';
import '../mocks/subject_info_mock.dart';

void main() {
  group("Input Data Component Tests", () {
    final InstitutionInfoMock currentInstitutionMock = InstitutionInfoMock();
    final SubjectInfoMock currentSubjectMock = SubjectInfoMock();

    testWidgets('input uneaten food data tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodInputDialog(
            currentInstitutionMock, currentSubjectMock, FoodStatus.uneaten),
      ));

      Config.log.i("Check if we are on the right page");
      final inputDataPageHeader = find.text('Capture Food Container');
      expect(inputDataPageHeader, findsOneWidget);

      final foodNameInputField = find.text("Name of Food Item");
      final foodWeightInputField = find.widgetWithText(
          TextFormField, "Weight(g)");
      final foodCommentInputField = find.widgetWithText(
          TextFormField, "Comments");
      final foodItemSubmitBtn = find.widgetWithText(ElevatedButton, "Submit");
      final foodItemRetakePhotoBtn = find.widgetWithText(
          ElevatedButton, "Retake Photo");

      Config.log.i(
          "Check the input options in Food Item form are presented correctly");
      expect(foodNameInputField, findsOneWidget);
      expect(foodWeightInputField, findsOneWidget);
      expect(foodCommentInputField, findsOneWidget);
      expect(foodItemSubmitBtn, findsOneWidget);
      expect(foodItemRetakePhotoBtn, findsOneWidget);

      Config.log.i("Check the food presets are presented correctly");
      List<String> presetFoodItems = ["Apple", "Sandwich", "Juice"];
      for (String foodItem in presetFoodItems) {
        final foodItemBtn = find.widgetWithText(ElevatedButton, foodItem);
        expect(foodItemBtn, findsOneWidget);
      }
    });


    testWidgets('input eaten food data tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodInputDialog(
            currentInstitutionMock, currentSubjectMock, FoodStatus.eaten),
      ));

      Config.log.i("Check if we are on the right page");
      final inputDataPageHeader = find.text('Capture Food Container');
      expect(inputDataPageHeader, findsOneWidget);

      final foodWeightInputField = find.widgetWithText(
          TextFormField, "Weight(g)");
      final foodCommentInputField = find.widgetWithText(
          TextFormField, "Comments");
      final foodItemSubmitBtn = find.widgetWithText(ElevatedButton, "Submit");
      final foodItemRetakePhotoBtn = find.widgetWithText(
          ElevatedButton, "Retake Photo");

      Config.log.i(
          "Check the input options in Food Item form are presented correctly");
      expect(foodWeightInputField, findsOneWidget);
      expect(foodCommentInputField, findsOneWidget);
      expect(foodItemSubmitBtn, findsOneWidget);
      expect(foodItemRetakePhotoBtn, findsOneWidget);

      Config.log.i("Check the eaten food presets are presented correctly");
      final foodItem = "Apple";
      final foodItemBtn = find.widgetWithText(ElevatedButton, foodItem);
      expect(foodItemBtn, findsNWidgets(5));

    });


    testWidgets('input container data tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodInputDialog(
            currentInstitutionMock, currentSubjectMock, FoodStatus.container),
      ));

      Config.log.i("Check if we are on the right page");
      final inputDataPageHeader = find.text('Capture Eaten Food Container');
      expect(inputDataPageHeader, findsOneWidget);

      final foodWeightInputField = find.widgetWithText(
          TextFormField, "Weight(g)");
      final foodCommentInputField = find.widgetWithText(
          TextFormField, "Comments");
      final foodItemSubmitBtn = find.widgetWithText(ElevatedButton, "Submit");
      final foodItemRetakePhotoBtn = find.widgetWithText(
          ElevatedButton, "Retake Photo");

      Config.log.i(
          "Check the input options in Container form are presented correctly");
      expect(foodWeightInputField, findsOneWidget);
      expect(foodCommentInputField, findsOneWidget);
      expect(foodItemSubmitBtn, findsOneWidget);
      expect(foodItemRetakePhotoBtn, findsOneWidget);

    });
  });
}
