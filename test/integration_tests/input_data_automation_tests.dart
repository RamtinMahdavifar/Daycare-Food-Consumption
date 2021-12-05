import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Input Data Automation Tests",() {
    testWidgets("input Data Test", (WidgetTester tester) async {
      Config.log.i("Launch the app");
      app.main();
      await tester.pumpAndSettle();

      Config.log.i("Check the SelectInstitution widget is presented");
      final appHeader = find.text("Plate Waste Tracker");
      expect(appHeader, findsOneWidget);

      final addInstitutionButton = find.byIcon(Icons.add);

      Config.log.i("Click the Add Institution Button");
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the AddInstitutionForm widget is presented");
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");
      final numberOfSubjects = find.widgetWithText(TextFormField, "# of subjects:");

      Config.log.i("Fill in the form with some data");
      await tester.enterText(institutionName, "Saskatoon");
      await tester.enterText(numberOfSubjects, "11");
      await tester.enterText(institutionAddress, "Campus Dr");
      await tester.pumpAndSettle();

      Config.log.i("Click submit button");
      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      Config.log.i("Check Saskatoon should appear in the list view.");
      final newCreatedInstitution = find.bySemanticsLabel("Saskatoon");
      expect(newCreatedInstitution, findsOneWidget);

      Config.log.i("Click the Saskatoon");
      await tester.tap(newCreatedInstitution);
      await tester.pumpAndSettle();

      final inputDataButton = find.text("Input Data");

      Config.log.i("Click Input Data");
      await tester.tap(inputDataButton);
      await tester.pumpAndSettle();

      Config.log.i("Check we are in input data page now");
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final uneatenButton = find.widgetWithText(ElevatedButton, "uneaten");
      final eatenButton = find.widgetWithText(ElevatedButton, "eaten");
      final containerButton = find.widgetWithText(ElevatedButton, "container");

      Config.log.i("uneaten button is presented");
      expect(uneatenButton, findsOneWidget);
      Config.log.i("eaten button is presented");
      expect(eatenButton, findsOneWidget);
      Config.log.i("container button is presented");
      expect(containerButton, findsOneWidget);

      Config.log.i("Uneaten Button is presented");
      await tester.tap(uneatenButton);
      await tester.pumpAndSettle();

      final manualIDButton = find.widgetWithText(ElevatedButton, "Manual ID Entry");

      Config.log.i("Check Manual ID Entry button is present");
      expect(manualIDButton, findsOneWidget);

      Config.log.i("Click Manual ID Entry button");
      await tester.tap(manualIDButton);
      await tester.pumpAndSettle();

      final inputIDForm = find.widgetWithText(AlertDialog, "ID");

      Config.log.i("Check the ID entry pop up is presented");
      expect(inputIDForm, findsOneWidget);

      final idInputFields = find.widgetWithIcon(TextFormField, Icons.perm_identity);

      Config.log.i("Check the ID entry pop up is presented");
      expect(idInputFields, findsOneWidget);

      Config.log.i("Enter the ID 1");
      await tester.enterText(idInputFields, "ID 1");
      await tester.pumpAndSettle();

      final inputIDCancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      final inputIDSubmitButton = find.widgetWithText(ElevatedButton, "Submit");

      Config.log.i("The buttons for ID Input Dialog are present");
      expect(inputIDCancelButton, findsOneWidget);
      expect(inputIDSubmitButton, findsOneWidget);

      Config.log.i("Click Input ID Submit Button");
      await tester.tap(inputIDSubmitButton);
      await tester.pumpAndSettle();

      final foodCaptureHeader = find.text("Capture Uneaten Food Item");
      Config.log.i("Check the Food Capture widget is presented");
      expect(foodCaptureHeader, findsOneWidget);
      
      final subjectName = find.text("ID 1");
      Config.log.i("Check the subject name is presented correctly");
      expect(subjectName, findsOneWidget);

      final capturePhotoBtn = find.widgetWithIcon(ElevatedButton, Icons.camera_alt);
      Config.log.i("Check the Capture Photo Button is presented correctly");
      expect(capturePhotoBtn, findsOneWidget);

      final viewDataBtn = find.widgetWithText(ElevatedButton, "View Data");
      Config.log.i("Check the View Data Button is presented correctly");
      expect(viewDataBtn, findsOneWidget);

      final finishBtn = find.widgetWithText(ElevatedButton, "Finish");
      Config.log.i("Check the Finish Button is presented correctly");
      expect(finishBtn, findsOneWidget);

      Config.log.i("Click the Capture Photo Button");
      await tester.tap(capturePhotoBtn);
      await tester.pumpAndSettle();

      Config.log.i("Check the Food Capture widget is presented");
      expect(foodCaptureHeader, findsOneWidget);

      final foodNameInputField = find.text("Name of Food Item");
      final foodWeightInputField = find.widgetWithText(TextFormField, "Weight(g)");
      final foodCommentInputField = find.widgetWithText(TextFormField, "Comments");
      final foodItemSubmitBtn = find.widgetWithText(ElevatedButton, "Submit");
      final foodItemRetakePhotoBtn = find.widgetWithText(ElevatedButton, "Retake Photo");

      Config.log.i("Check the input options in Food Item form are presented correctly");
      expect(foodNameInputField, findsOneWidget);
      expect(foodWeightInputField, findsOneWidget);
      expect(foodCommentInputField, findsOneWidget);
      expect(foodItemSubmitBtn, findsOneWidget);
      expect(foodItemRetakePhotoBtn, findsOneWidget);

      Config.log.i("Check the food presets are presented correctly");
      List<String> presetFoodItems = ["Apple", "Sandwich", "Juice"];
      for (String foodItem in presetFoodItems){
        final foodItemBtn = find.widgetWithText(ElevatedButton, foodItem);
        expect(foodItemBtn, findsOneWidget);
      }

      Config.log.i("Input the data to the forum");
      final apple = find.widgetWithText(ElevatedButton, "Apple");
      await tester.tap(apple);
      await tester.enterText(foodWeightInputField, "20");
      await tester.enterText(foodCommentInputField, "Student A had an apple.");

      Config.log.i("Click Submit button");
      await tester.tap(foodItemSubmitBtn);
      await tester.pumpAndSettle();

      Config.log.i("Check we submit the data successfully");
      expect(capturePhotoBtn, findsOneWidget);

      Config.log.i("Click Finish button");
      await tester.tap(finishBtn);
      await tester.pumpAndSettle();

      Config.log.i("Check the Finish buton works");
      expect(manualIDButton, findsOneWidget);
    });
  });
}