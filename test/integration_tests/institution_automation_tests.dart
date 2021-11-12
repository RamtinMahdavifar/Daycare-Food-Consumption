import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Institution Automation Tests",() {
    testWidgets("Add An Institution Test", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //SUT, in this case login the application
      final emailInput = find.widgetWithText(TextField, "Email");
      final passwordInput = find.widgetWithText(TextField, "Password");
      await tester.enterText(emailInput, "123@usask.ca");
      await tester.enterText(passwordInput, "abc123");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, "Login"), findsOneWidget);
      final loginButton = find.widgetWithText(ElevatedButton, "Login");
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      expect(find.text("Plate Waste Tracker"), findsOneWidget);

      final addInstitutionButton = find.byIcon(Icons.add);
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is presented
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");
      final numberOfSubjects = find.widgetWithText(TextFormField, "# of subjects:");
      await tester.enterText(institutionName, "University of Saskatchewan");
      await tester.enterText(numberOfSubjects, "11");
      await tester.enterText(institutionAddress, "No 1 Campus Dr");
      await tester.pumpAndSettle();

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is closed
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);

      //The University of Saskatchewan should not appear in the list view
      expect(find.bySemanticsLabel("University of Saskatchewan"), findsNothing);

      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      await tester.enterText(institutionName, "University");
      await tester.enterText(institutionAddress, "No 2 Campus Dr");
      await tester.enterText(numberOfSubjects, "22");
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is closed
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);

      //The University of Regina should appear in the list view.
      expect(find.text("University"), findsOneWidget);

      final firstInstitution = find.bySemanticsLabel("University");
      await tester.tap(firstInstitution);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is closed
      expect(find.text("Plate Waste Tracker"), findsNothing);

      // Verify InstitutionPage is presented with correct Institution Name
      expect(find.text("University"), findsOneWidget);

      //Click back icon
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      expect(find.text("Plate Waste Tracker"), findsOneWidget);

      await tester.tap(firstInstitution);
      await tester.pumpAndSettle();

      // verify that the institution info are presented correctly
      expect(find.text( "Address: No 2 Campus Dr"), findsOneWidget);

      //Check all button widgets in institution page are presented
      final rosterButton = find.text("Roster");
      final presetButton = find.text("Preset");
      final viewDataButton = find.text("View Data");
      final inputDataButton = find.text("Input Data");

      expect(rosterButton, findsOneWidget);
      expect(presetButton, findsOneWidget);
      expect(viewDataButton, findsOneWidget);
      expect(inputDataButton, findsOneWidget);
    });


    testWidgets("Add An Institution Test With Empty String", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      //SUT, in this case login the application
      final emailInput = find.widgetWithText(TextField, "Email");
      final passwordInput = find.widgetWithText(TextField, "Password");
      await tester.enterText(emailInput, "123@usask.ca");
      await tester.enterText(passwordInput, "abc123");
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, "Login"), findsOneWidget);
      final loginButton =  find.widgetWithText(ElevatedButton, "Login");
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify the institution widget is presented
      expect(find.text("Plate Waste Tracker"), findsOneWidget);

      final addInstitutionButton = find.byIcon(Icons.add);
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is presented
      expect(find.byIcon(Icons.home), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");
      final numberOfSubjects = find.widgetWithText(TextFormField, "# of subjects:");

      await tester.enterText(institutionName, "");
      await tester.enterText(institutionAddress, "");
      await tester.enterText(numberOfSubjects, "");
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify the error messages occurs in all text input fields
      expect(find.text("Value Can't Be Empty"), findsNWidgets(3));

      // Verify the AddInstitutionForm widget was not closed
      expect(find.byIcon(Icons.home), findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      expect(find.text("Plate Waste Tracker"), findsOneWidget);
    });
  });
}