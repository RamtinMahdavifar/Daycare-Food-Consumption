import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Institution Automation Tests",() {
    testWidgets("Add An Institution Test", (WidgetTester tester) async {
      Config.log.i("Launch the app");
      app.main();
      await tester.pumpAndSettle();

      Config.log.i("Check the SelectInstitution widget is presented");
      expect(find.text("Plate Waste Tracker"), findsOneWidget);

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
      await tester.enterText(institutionName, "University of Saskatchewan");
      await tester.enterText(numberOfSubjects, "11");
      await tester.enterText(institutionAddress, "No 1 Campus Dr");
      await tester.pumpAndSettle();

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");

      Config.log.i("Click cancel button");
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the AddInstitutionForm widget is closed");
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);

      Config.log.i("Check the University of Saskatchewan should not appear in the list view");
      expect(find.bySemanticsLabel("University of Saskatchewan"), findsNothing);

      Config.log.i("Click the Add Institution Button");
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      Config.log.i("Fill in the form with some data");
      await tester.enterText(institutionName, "Yoda");
      await tester.enterText(institutionAddress, "Dagobah");
      await tester.enterText(numberOfSubjects, "22");
      await tester.pumpAndSettle();

      Config.log.i("Click submit button");
      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the AddInstitutionForm widget is closed");
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);

      Config.log.i("Check Dagobah should appear in the list view.");
      final newCreatedInstitution = find.bySemanticsLabel("Yoda");
      expect(newCreatedInstitution, findsOneWidget);

      Config.log.i("Click the Yoda");
      await tester.tap(newCreatedInstitution);
      await tester.pumpAndSettle();

      Config.log.i("Check the SelectInstitution widget is closed");
      expect(find.text("Plate Waste Tracker"), findsNothing);

      Config.log.i("Check institutionPage is presented with correct Institution Name");
      expect(find.text("Yoda"), findsOneWidget);

      Config.log.i("Click back icon");
      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the SelectInstitution widget is presented");
      expect(find.text("Plate Waste Tracker"), findsOneWidget);

      Config.log.i("Click the Yoda");
      await tester.tap(newCreatedInstitution);
      await tester.pumpAndSettle();

      Config.log.i("Check that the institution info are presented correctly");
      expect(find.text( "Address: Dagobah"), findsOneWidget);

      final rosterButton = find.text("Roster");
      final presetButton = find.text("Preset");
      final viewDataButton = find.text("View Data");
      final inputDataButton = find.text("Input Data");

      Config.log.i("Check all button widgets in institution page are presented");
      expect(rosterButton, findsOneWidget);
      expect(presetButton, findsOneWidget);
      expect(viewDataButton, findsOneWidget);
      expect(inputDataButton, findsOneWidget);
    });


    testWidgets("Add An Institution Test With Empty String", (WidgetTester tester) async {
      Config.log.i("Launch the app");
      app.main();
      await tester.pumpAndSettle();

      Config.log.i("Check the institution widget is presented");
      expect(find.text("Plate Waste Tracker"), findsOneWidget);

      final addInstitutionButton = find.byIcon(Icons.add);

      Config.log.i("Click Add Institution Button");
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the AddInstitutionForm widget is presented");
      expect(find.byIcon(Icons.home), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");
      final numberOfSubjects = find.widgetWithText(TextFormField, "# of subjects:");

      Config.log.i("Fill in the empty data to the form");
      await tester.enterText(institutionName, "");
      await tester.enterText(institutionAddress, "");
      await tester.enterText(numberOfSubjects, "");
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, "Submit");

      Config.log.i("Click Submit Button");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the error messages occurs in all text input fields");
      expect(find.text("Value Can't Be Empty"), findsNWidgets(3));

      Config.log.i("Check the AddInstitutionForm widget was not closed");
      expect(find.byIcon(Icons.home), findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");

      Config.log.i("Click Cancel Button");
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      Config.log.i("Check the SelectInstitution widget is presented");
      expect(find.text("Plate Waste Tracker"), findsOneWidget);
    });
  });
}