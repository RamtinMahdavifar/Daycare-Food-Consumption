import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/institution_page.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/View/roster_page.dart';


void main() {
  group("Roster page component tests", () {

    testWidgets(
        'Verify Roster Page is presented with correct information and widgets', (
        WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home:  Roster(InstitutionInfo("test", "test"))));

      //Check roster button widget in institution page is presented
      Config.log.i("Verify Roster Button is present");
      expect(find.text("Roster"), findsOneWidget);

      // Tap the Roster button
      Config.log.i("Press the widget button");
      await tester.tap(find.widgetWithText(ElevatedButton, "Roster"));
      await tester.pump();

      // Check if we are in roster page
      Config.log.i("Check Page Title");
      expect(find.widgetWithText(InstitutionPage, "Roster"), findsOneWidget);

      // Check if Roster entries exist
      Config.log.i("Check if roster entries exist");
      expect(find.widgetWithText(Text, "ID 0"), findsOneWidget);

      Config.log.i("Check if delete Roster entry button exists");
      expect(find.widgetWithIcon(ElevatedButton, Icons.highlight_remove).first, findsOneWidget);

      Config.log.i("Check if qr info button exists");
      expect(find.widgetWithIcon(ElevatedButton, Icons.qr_code).first, findsOneWidget);

      Config.log.i("Check if edit roster info button exists");
      expect(find.widgetWithIcon(ElevatedButton, Icons.mode_edit).first, findsOneWidget);

    });

    testWidgets(
        'Verify Roster Page Delete button works', (
        WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: InstitutionPage("test", "test")));

      //Check roster button widget in institution page is presented
      Config.log.i("Verify Roster Button is present");
      expect(find.text("Roster"), findsOneWidget);

      // Tap the Roster button
      Config.log.i("Press the widget button");
      await tester.tap(find.widgetWithText(ElevatedButton, "Roster"));
      await tester.pump();

      // Check if delete button works
      Config.log.i("Check if delete button works");
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.highlight_remove).first);
      await tester.pumpAndSettle();
    });

    testWidgets(
        'Verify Roster Page QR button works', (
        WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: InstitutionPage("test", "test")));

      //Check roster button widget in institution page is presented
      Config.log.i("Verify Roster Button is present");
      expect(find.text("Roster"), findsOneWidget);

      // Tap the Roster button
      Config.log.i("Press the widget button");
      await tester.tap(find.widgetWithText(ElevatedButton, "Roster"));
      await tester.pump();

      // check if Qr button works
      Config.log.i("Check if QR button works");
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.qr_code));
      await tester.pump();
    });

    testWidgets(
        'Verify Roster Page Edit Info button works', (
        WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: InstitutionPage("test", "test")));

      //Check roster button widget in institution page is presented
      Config.log.i("Verify Roster Button is present");
      expect(find.text("Roster"), findsOneWidget);

      // Tap the Roster button
      Config.log.i("Press the widget button");
      await tester.tap(find.widgetWithText(ElevatedButton, "Roster"));
      await tester.pump();

      // check if View/Edit Data button work
      Config.log.i("Check if Edit Information button works");
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.mode_edit));
      await tester.pump();
    });
  });
}