import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Input Data Automation Tests",() {
    testWidgets("input Data Test", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //SUT, in this case login the application
      final emailInput = find.widgetWithText(TextField, "Email");
      final passwordInput = find.widgetWithText(TextField, "Password");
      await tester.enterText(emailInput, "123@usask.ca");
      await tester.enterText(passwordInput, "abc123");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(seconds: 1));

      final loginButton = find.widgetWithText(ElevatedButton, "Login");
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      final appHeader = find.text("Plate Waste Tracker");
      expect(appHeader, findsOneWidget);

      final addInstitutionButton = find.byIcon(Icons.add);
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is presented
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");
      final numberOfSubjects = find.widgetWithText(TextFormField, "# of subjects:");

      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      await tester.enterText(institutionName, "University");
      await tester.enterText(institutionAddress, "No 2 Campus Dr");
      await tester.enterText(numberOfSubjects, "22");
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      final firstInstitution = find.bySemanticsLabel("University");
      await tester.tap(firstInstitution);
      await tester.pumpAndSettle();

      final inputDataButton = find.text("Input Data");
      await tester.tap(inputDataButton);
      await tester.pumpAndSettle();

      //Verify we are in input data page now
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final foodType1Button = find.widgetWithText(ElevatedButton, "Food Type 1");
      final foodType2Button = find.widgetWithText(ElevatedButton, "Food Type 2");
      final foodType3Button = find.widgetWithText(ElevatedButton, "Food Type 3");

      expect(foodType1Button, findsOneWidget);
      expect(foodType2Button, findsOneWidget);
      expect(foodType3Button, findsOneWidget);

      final nameInputFields = find.byType(TextField).at(0);
      final weightInputField = find.byType(TextField).at(1);
      final commentsInputField = find.byType(TextField).at(2);
      final galleryButton = find.widgetWithIcon(ElevatedButton, Icons.photo);
      final cameraButton = find.widgetWithIcon(ElevatedButton, Icons.camera_alt);

      await tester.tap(foodType1Button);
      await tester.pumpAndSettle();
      expect(find.text("Upload Data"), findsOneWidget);

      //Verify all the input fields and buttons in upload data forum are presented
      expect(nameInputFields, findsOneWidget);
      expect(weightInputField, findsOneWidget);
      expect(commentsInputField, findsOneWidget);
      expect(galleryButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);

      //Input the data to the forum
      await tester.enterText(nameInputFields, "Apple");
      await tester.enterText(weightInputField, "20");
      await tester.enterText(commentsInputField, "Student A had an apple.");
      await tester.pumpAndSettle();

      //Verify the data that we entered are presented
      expect(find.text("Apple"), findsOneWidget);
      expect(find.text("20"), findsOneWidget);
      expect(find.text("Student A had an apple."), findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      //Verify we are in input data page now
      expect(inputDataPageHeader, findsOneWidget);

      await tester.tap(foodType2Button);
      await tester.pumpAndSettle();
      expect(find.text("Upload Data"), findsOneWidget);

      //Verify all the input fields and buttons in upload data forum are presented
      expect(nameInputFields, findsOneWidget);
      expect(weightInputField, findsOneWidget);
      expect(commentsInputField, findsOneWidget);
      expect(galleryButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);

      //Enter the data to the forum
      await tester.enterText(nameInputFields, "Grape");
      await tester.enterText(weightInputField, "11");
      await tester.enterText(commentsInputField, "Student A had grape.");
      await tester.pumpAndSettle();

      //Verify the data that we entered are presented
      expect(find.text("Grape"), findsOneWidget);
      expect(find.text("11"), findsOneWidget);
      expect(find.text("Student A had grape."), findsOneWidget);

      await tester.tap(backButton);
      await tester.pumpAndSettle();

      //Verify we are in input data page now
      expect(inputDataPageHeader, findsOneWidget);

      await tester.tap(foodType3Button);
      await tester.pumpAndSettle();
      expect(find.text("Upload Data"), findsOneWidget);

      //Verify all the input fields and buttons in upload data forum are presented
      expect(nameInputFields, findsOneWidget);
      expect(weightInputField, findsOneWidget);
      expect(commentsInputField, findsOneWidget);
      expect(galleryButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);

      //Enter the data to the forum
      await tester.enterText(nameInputFields, "Pineapple");
      await tester.enterText(weightInputField, "23");
      await tester.enterText(commentsInputField, "Student A had pineapple.");
      await tester.pumpAndSettle();

      //Verify the data that we entered are presented
      expect(find.text("Pineapple"), findsOneWidget);
      expect(find.text("23"), findsOneWidget);
      expect(find.text("Student A had pineapple."), findsOneWidget);

      //TODO: need to figure out how to capturing photo in test
      //https://github.com/UniversityOfSaskatchewanCMPT371/term-project-fall-2021-team-2-1/issues/10
    });
  });
}