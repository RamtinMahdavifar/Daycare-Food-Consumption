import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/food_status_page.dart';
// import 'package:plate_waste_recorder/View/upload_data.dart';
import 'package:plate_waste_recorder/Helper/config.dart';



void main() {
  group("Input Data Component Tests",() {
    testWidgets('input ui tests', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: FoodStatusPage(),
      ));
      Config.log.i("Component Testing - Input Data");
      //Verify the input data page header is showing correctly
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final foodType1Button = find.widgetWithText(ElevatedButton, "Food Uneaten");
      final foodType2Button = find.widgetWithText(ElevatedButton, "Food Eaten: not thrown out");
      final foodType3Button = find.widgetWithText(ElevatedButton, "Food Wasted: container weight");

      //Verify all food options are presented
      Config.log.i("Verify all food options are present");
      Config.log.i("Food Type 1 button is present");
      expect(foodType1Button, findsOneWidget);
      Config.log.i("Food Type 2 button is present");
      expect(foodType2Button, findsOneWidget);
      Config.log.i("Food Type 3 button is present");
      expect(foodType3Button, findsOneWidget);
    });
    //  TODO - uncomment code when Input Data is implemented
    //  (https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/issues/106)
    //   //Open the Food Type 1
    //   await tester.tap(foodType1Button);
    //   await tester.pumpAndSettle();
    //
    //   //verify the upload data page header is correct
    //   final uploadPageHeader = find.text("Upload Data");
    //   Config.log.i("Food Type 1 - Verify upload data page header is present");
    //   expect(uploadPageHeader, findsOneWidget);
    //
    //   final nameInputFields = find.byType(TextField).at(0);
    //   final weightInputField = find.byType(TextField).at(1);
    //   final commentsInputField = find.byType(TextField).at(2);
    //   final galleryButton = find.widgetWithIcon(ElevatedButton, Icons.photo);
    //   final cameraButton = find.widgetWithIcon(ElevatedButton, Icons.camera_alt);
    //
    //   //Verify all the input fields and buttons in upload data forum are presented
    //   Config.log.i("Food Type 1 - Verify all expected buttons and fields are present");
    //   Config.log.i("Food Type 1 - name input field is present");
    //   expect(nameInputFields, findsOneWidget);
    //   Config.log.i("Food Type 1 - weight input field is present");
    //   expect(weightInputField, findsOneWidget);
    //   Config.log.i("Food Type 1 - comments input field is present");
    //   expect(commentsInputField, findsOneWidget);
    //   Config.log.i("Food Type 1 - comments gallery button is present");
    //   expect(galleryButton, findsOneWidget);
    //   Config.log.i("Food Type 1 - comments camera field is present");
    //   expect(cameraButton, findsOneWidget);
    //
    //   final backButton = find.byIcon(Icons.arrow_back);
    //   await tester.tap(backButton);
    //   await tester.pumpAndSettle();
    //
    //   //Open the Food Type 2
    //   await tester.tap(foodType2Button);
    //   await tester.pumpAndSettle();
    //
    //   //verify the upload data page header is correct
    //   Config.log.i("Food Type 2 - Verify upload data page header is present");
    //   expect(uploadPageHeader, findsOneWidget);
    //
    //   //Verify all the input fields and buttons in upload data forum are presented
    //   Config.log.i("Food Type 2 - Verify all expected buttons and fields are present");
    //   Config.log.i("Food Type 2 - name input field is present");
    //   expect(nameInputFields, findsOneWidget);
    //   Config.log.i("Food Type 2 - weight input field is present");
    //   expect(weightInputField, findsOneWidget);
    //   Config.log.i("Food Type 2 - comments input field is present");
    //   expect(commentsInputField, findsOneWidget);
    //   Config.log.i("Food Type 2 - comments gallery button is present");
    //   expect(galleryButton, findsOneWidget);
    //   Config.log.i("Food Type 2 - comments camera field is present");
    //   expect(cameraButton, findsOneWidget);
    //
    //   await tester.tap(backButton);
    //   await tester.pumpAndSettle();
    //
    //   //Open the Food Type 3
    //   await tester.tap(foodType3Button);
    //   await tester.pumpAndSettle();
    //
    //   //verify the upload data page header is correct
    //   Config.log.i("Food Type 3 - Verify upload data page header is present");
    //   expect(uploadPageHeader, findsOneWidget);
    //
    //   //Verify all the input fields and buttons in upload data forum are presented
    //   Config.log.i("Food Type 3 - Verify all expected buttons and fields are present");
    //   Config.log.i("Food Type 3 - name input field is present");
    //   expect(nameInputFields, findsOneWidget);
    //   Config.log.i("Food Type 3 - weight input field is present");
    //   expect(weightInputField, findsOneWidget);
    //   Config.log.i("Food Type 3 - comments input field is present");
    //   expect(commentsInputField, findsOneWidget);
    //   Config.log.i("Food Type 3 - comments gallery button is present");
    //   expect(galleryButton, findsOneWidget);
    //   Config.log.i("Food Type 3 - comments camera field is present");
    //   expect(cameraButton, findsOneWidget);
    //
    //   //TODO: still need to verify the device camera is presented correctly
    //   //https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/issues/10
    // });
  });
}