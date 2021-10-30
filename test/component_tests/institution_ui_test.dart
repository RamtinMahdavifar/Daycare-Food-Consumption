import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/institution_page.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';

void main() {
  group("Institution UI Tests",() {
    testWidgets('Add Institution smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home:  ChooseInstitute()));

      // Verify the institution widget is presented
      expect(find.widgetWithText(ChooseInstitute, "Plate Waste Tracker"), findsOneWidget);

      // verify that the Text widgets appear exactly once in the widget tree.
      expect(find.text("Add Institution"), findsOneWidget);
      expect(find.text("Search Institutions"), findsOneWidget);

      //Tap the "+ Add Institution" button to trigger a dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify the AddInstitutionForm widget is presented
      expect(find.byIcon(Icons.location_on_outlined), findsWidgets);

      // verify that the Text widgets appear exactly once in the widget tree.
      expect(find.widgetWithText(TextFormField, "name"), findsOneWidget);
      expect(find.widgetWithText(TextFormField, "address"), findsOneWidget);
      expect(find.widgetWithText(TextFormField, "# of subjects:"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Cancel"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Submit"), findsOneWidget);

      await tester.tap(find.text("Cancel"));
      await tester.pump();

      // Verify the AddInstitutionForm widget is closed
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);

      // verify that the Text widgets appear exactly once in the widget tree.
      expect(find.text("Add Institution"), findsOneWidget);
      expect(find.text("Search Institutions"), findsOneWidget);

      // Verify the institution widget is presented
      expect(find.widgetWithText(ChooseInstitute, "Plate Waste Tracker"), findsOneWidget);
    });

    testWidgets('Institution Page', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home:  InstitutionPage("University", "123 Street")));

      // Verify InstitutionPage is presented with correct Institution Name
      expect(find.widgetWithText(InstitutionPage, "University"), findsOneWidget);
      expect(find.widgetWithText(InstitutionPage, "Address: 123 Street"), findsOneWidget);

      // Verify that the back button is presented
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // verify that the institution info are presented correctly
      expect(find.text( "Address: 123 Street"), findsOneWidget);

      //Check all button widgets in institution page are presented
      expect(find.text("Roster"), findsOneWidget);
      expect(find.text("Preset"), findsOneWidget);
      expect(find.text("View Data"), findsOneWidget);
      expect(find.text("Input Data"), findsOneWidget);
    });
  });
}