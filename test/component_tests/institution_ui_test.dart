import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/institution_page.dart';
import 'package:plate_waste_recorder/View/select_institution.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

void main() {
  group("Institution UI Tests",() {
    testWidgets('Verify the institution widget is presented', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
          home:  ChooseInstitute())
      );
      Config.log.i("Component Testing - Institution");
      expect(find.widgetWithText(ChooseInstitute, "Plate Waste Tracker"), findsOneWidget);

      Config.log.i("Check the Add Institution button and Search Institution box are presented");
      expect(find.text("Add Institution"), findsOneWidget);
      expect(find.text("Search Institutions"), findsOneWidget);
    });

    testWidgets('Verify the AddInstitutionForm widget is presented', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
          home:  ChooseInstitute()));

      Config.log.i("Tap the + Add Institution button to trigger a dialog");
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.byIcon(Icons.location_on_outlined), findsWidgets);

      Config.log.i("The title and the placeholder text are presented correctly");
      expect(find.widgetWithText(TextFormField, "name"), findsOneWidget);
      expect(find.widgetWithText(TextFormField, "address"), findsOneWidget);
      expect(find.widgetWithText(TextFormField, "# of subjects:"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Cancel"), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, "Submit"), findsOneWidget);
    });

    testWidgets('Verify the institution widget is presented correctly after the AddInstitutionForm is closed', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
          home: ChooseInstitute()));

      Config.log.i("Tap the + Add Institution button to trigger a dialog");
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      Config.log.i("Click the Cancel Button");
      await tester.tap(find.text("Cancel"));
      await tester.pump();

      Config.log.i("Check the AddInstitutionForm widget is closed");
      expect(find.byIcon(Icons.location_on_outlined), findsNothing);
      expect(find.widgetWithText(ChooseInstitute, "Plate Waste Tracker"), findsOneWidget);

      Config.log.i("Check the institution page is presented");
      expect(find.text("Add Institution"), findsOneWidget);
      expect(find.text("Search Institutions"), findsOneWidget);
    });

    testWidgets('Verify InstitutionPage is presented with correct information and widgets', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
          home:  InstitutionPage("University", "123 Street")));

      Config.log.i("Check the data are presented correctly");
      expect(find.widgetWithText(InstitutionPage, "University"), findsOneWidget);
      expect(find.widgetWithText(InstitutionPage, "Address: 123 Street"), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      Config.log.i("Check the institution info are presented correctly");
      expect(find.text( "Address: 123 Street"), findsOneWidget);

      Config.log.i("Check all button widgets in institution page are presented");
      expect(find.text("Roster"), findsOneWidget);
      expect(find.text("Preset"), findsOneWidget);
      expect(find.text("View Data"), findsOneWidget);
      expect(find.text("Input Data"), findsOneWidget);
    });
  });
}