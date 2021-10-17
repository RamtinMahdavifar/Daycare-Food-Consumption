import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/View/add_institutions_form.dart';
import 'package:plate_waste_recorder/View/institution_page.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';
import 'package:plate_waste_recorder/View/upload_data.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Institution Automation Tests",() {
    testWidgets("Add An Institution Test", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      expect(find.widgetWithText(SelectInstitute, "Plate Waste Tracker"), findsOneWidget);

      final addInstitutionButton = find.text("Add Institution");
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is presented
      expect(find.widgetWithIcon(AddInstitutionForm, Icons.location_on_outlined), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");

      await tester.enterText(institutionName, "University of Saskatchewan");
      await tester.enterText(institutionAddress, "No 1 Campus Dr");
      await tester.pumpAndSettle();

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is closed
      expect(find.widgetWithIcon(AddInstitutionForm, Icons.location_on_outlined), findsNothing);

      //The University of Saskatchewan should not appear in the list view
      expect(find.bySemanticsLabel("University of Saskatchewan"), findsNothing);

      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      await tester.enterText(institutionName, "University");
      await tester.enterText(institutionAddress, "No 2 Campus Dr");
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is closed
      expect(find.widgetWithIcon(AddInstitutionForm, Icons.location_on_outlined), findsNothing);

      //The University of Regina should appear in the list view.
      expect(find.text("University"), findsOneWidget);

      final firstInstitution = find.bySemanticsLabel("University");
      await tester.tap(firstInstitution);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is closed
      expect(find.widgetWithText(SelectInstitute, "Plate Waste Tracker"), findsNothing);

      // Verify InstitutionPage is presented with correct Institution Name
      expect(find.widgetWithText(InstitutionPage, "University"), findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      expect(find.widgetWithText(SelectInstitute, "Plate Waste Tracker"), findsOneWidget);

      await tester.tap(firstInstitution);
      await tester.pumpAndSettle();

      // verify that the institution info are presented correctly
      expect(find.text( "Address: No 2 Campus Dr"), findsOneWidget);

      //Check all button widgets in institution page are presented
      final QRCodeButton = find.text("QR Code");
      final cameraButton = find.text("Camera");
      final rosterButton = find.text("Roster");
      final recordDataButton = find.text("Record Data");
      final viewDataButton = find.text("View Data");
      final foodButton = find.text("Food");

      expect(QRCodeButton, findsOneWidget);
      expect(cameraButton, findsOneWidget);
      expect(rosterButton, findsOneWidget);
      expect(recordDataButton, findsOneWidget);
      expect(viewDataButton, findsOneWidget);
      expect(foodButton, findsOneWidget);

      await tester.tap(cameraButton);
      await tester.pumpAndSettle();

      // Verify the UploadData widget is presented
      expect(find.widgetWithText(UploadData, "Upload Data"), findsOneWidget);
    });


    testWidgets("Add An Institution Test With Empty String", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the institution widget is presented
      expect(find.widgetWithText(SelectInstitute, "Plate Waste Tracker"), findsOneWidget);

      final addInstitutionButton = find.text("Add Institution");
      await tester.tap(addInstitutionButton);
      await tester.pumpAndSettle();

      // Verify the AddInstitutionForm widget is presented
      expect(find.widgetWithIcon(AddInstitutionForm, Icons.home), findsOneWidget);

      final institutionName = find.widgetWithText(TextFormField, "name");
      final institutionAddress = find.widgetWithText(TextFormField, "address");

      await tester.enterText(institutionName, "");
      await tester.enterText(institutionAddress, "");
      await tester.pumpAndSettle();

      final submitButton = find.widgetWithText(ElevatedButton, "Submit");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify the error messages occurs in both text input fields
      expect(find.widgetWithText(TextFormField, "Value Can't Be Empty"), findsNWidgets(2));

      // Verify the AddInstitutionForm widget was not closed
      expect(find.widgetWithIcon(AddInstitutionForm, Icons.location_on_outlined), findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Verify the SelectInstitution widget is presented
      expect(find.widgetWithText(SelectInstitute, "Plate Waste Tracker"), findsOneWidget);
    });
  });
}