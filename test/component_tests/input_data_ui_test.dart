import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/food_status_page.dart';
import 'package:plate_waste_recorder/View/upload_data.dart';


void main() {
  group("Input Data Component Tests",() {
    testWidgets('input ui tests', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: FoodStatusPage(),
      ));

      //Verify the input data page header is showing correctly
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final foodType1Button = find.widgetWithText(ElevatedButton, "Food Uneaten");
      final foodType2Button = find.widgetWithText(ElevatedButton, "Food Eaten: not thrown out");
      final foodType3Button = find.widgetWithText(ElevatedButton, "Food Wasted: container weight");

      //Verify all food options are presented
      expect(foodType1Button, findsOneWidget);
      expect(foodType2Button, findsOneWidget);
      expect(foodType3Button, findsOneWidget);

      //Open the Food Type 1
      await tester.tap(foodType1Button);
      await tester.pumpAndSettle();

      //verify the upload data page header is correct
      final uploadPageHeader = find.text("Upload Data");
      expect(uploadPageHeader, findsOneWidget);

      final nameInputFields = find.byType(TextField).at(0);
      final weightInputField = find.byType(TextField).at(1);
      final commentsInputField = find.byType(TextField).at(2);
      final galleryButton = find.widgetWithIcon(ElevatedButton, Icons.photo);
      final cameraButton = find.widgetWithIcon(ElevatedButton, Icons.camera_alt);

      //Verify all the input fields and buttons in upload data forum are presented
      expect(nameInputFields, findsOneWidget);
      expect(weightInputField, findsOneWidget);
      expect(commentsInputField, findsOneWidget);
      expect(galleryButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      //Open the Food Type 2
      await tester.tap(foodType2Button);
      await tester.pumpAndSettle();

      //verify the upload data page header is correct
      expect(uploadPageHeader, findsOneWidget);

      //Verify all the input fields and buttons in upload data forum are presented
      expect(nameInputFields, findsOneWidget);
      expect(weightInputField, findsOneWidget);
      expect(commentsInputField, findsOneWidget);
      expect(galleryButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      //Open the Food Type 3
      await tester.tap(foodType3Button);
      await tester.pumpAndSettle();

      //verify the upload data page header is correct
      expect(uploadPageHeader, findsOneWidget);

      //Verify all the input fields and buttons in upload data forum are presented
      expect(nameInputFields, findsOneWidget);
      expect(weightInputField, findsOneWidget);
      expect(commentsInputField, findsOneWidget);
      expect(galleryButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);

      //TODO: still need to verify the device camera is presented correctly
      //https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/issues/10
    });
  });
}