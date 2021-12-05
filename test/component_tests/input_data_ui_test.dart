import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/food_status_page.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../mocks/institution_info_mock.dart';

void main() {
  group("Input Data Component Tests",() {
    final InstitutionInfoMock currentInstitutionMock = InstitutionInfoMock();

    testWidgets('select food status tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodStatusPage(currentInstitutionMock),
      ));

      Config.log.i("Component Test - select food status tests");
      //Verify the input data page header is showing correctly
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final foodType1Button = find.widgetWithText(ElevatedButton, "uneaten");
      final foodType2Button = find.widgetWithText(ElevatedButton, "eaten");
      final foodType3Button = find.widgetWithText(ElevatedButton, "container");

      //Verify all food options are presented
      Config.log.i("Verify all food options are present");
      Config.log.i("uneaten button is present");
      expect(foodType1Button, findsOneWidget);
      Config.log.i("eaten button is present");
      expect(foodType2Button, findsOneWidget);
      Config.log.i("container button is present");
      expect(foodType3Button, findsOneWidget);
    });

    testWidgets('uneaten option tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodStatusPage(currentInstitutionMock),
      ));
      Config.log.i("Component Test - uneaten option tests");
      //Verify the input data page header is showing correctly
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final uneatenButton = find.widgetWithText(ElevatedButton, "uneaten");
      Config.log.i("Food Type 1 button is present");
      await tester.tap(uneatenButton);
      await tester.pumpAndSettle();

      final studentIDScanner = find.text("Scan a Student ID");

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));

      final qrScanner = find.byType(QRView);

      Config.log.i("QR Scanner is present");
      expect(qrScanner, findsOneWidget);

      final manUalIDButton = find.widgetWithText(ElevatedButton, "Manual ID Entry");

      Config.log.i("Manual ID Entry button is present");
      expect(manUalIDButton, findsOneWidget);

      await tester.tap(manUalIDButton);
      await tester.pumpAndSettle();

      final inputIDForm = find.widgetWithText(AlertDialog, "ID");
      Config.log.i("the ID entry pop up is present");
      expect(inputIDForm, findsOneWidget);

      final idInputFields = find.widgetWithIcon(TextFormField, Icons.perm_identity);
      Config.log.i("the ID entry pop up is present");
      expect(idInputFields, findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      final submitButton = find.widgetWithText(ElevatedButton, "Submit");

      Config.log.i("The buttons for ID Input Dialog are present");
      expect(cancelButton, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));
    });

    testWidgets('eaten option tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodStatusPage(currentInstitutionMock),
      ));
      Config.log.i("Component Test - eaten option tests");
      //Verify the input data page header is showing correctly
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final eatenButton = find.widgetWithText(ElevatedButton, "eaten");
      Config.log.i("Eaten Button button is present");
      await tester.tap(eatenButton);
      await tester.pumpAndSettle();

      final studentIDScanner = find.text("Scan a Student ID");

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));

      final qrScanner = find.byType(QRView);

      Config.log.i("QR Scanner is present");
      expect(qrScanner, findsOneWidget);

      final manUalIDButton = find.widgetWithText(ElevatedButton, "Manual ID Entry");

      Config.log.i("Manual ID Entry button is present");
      expect(manUalIDButton, findsOneWidget);

      await tester.tap(manUalIDButton);
      await tester.pumpAndSettle();

      final inputIDForm = find.widgetWithText(AlertDialog, "ID");
      Config.log.i("the ID entry pop up is present");
      expect(inputIDForm, findsOneWidget);

      final idInputFields = find.widgetWithIcon(TextFormField, Icons.perm_identity);
      Config.log.i("the ID entry pop up is present");
      expect(idInputFields, findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      final submitButton = find.widgetWithText(ElevatedButton, "Submit");

      Config.log.i("The buttons for ID Input Dialog are present");
      expect(cancelButton, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));
    });

    testWidgets('container option tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: FoodStatusPage(currentInstitutionMock),
      ));
      Config.log.i("Component Test - container option tests");
      //Verify the input data page header is showing correctly
      final inputDataPageHeader = find.text('Select the food status');
      expect(inputDataPageHeader, findsOneWidget);

      final containerButton = find.widgetWithText(ElevatedButton, "container");
      Config.log.i("Container Button button is present");
      await tester.tap(containerButton);
      await tester.pumpAndSettle();

      final studentIDScanner = find.text("Scan a Student ID");

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));

      final qrScanner = find.byType(QRView);

      Config.log.i("QR Scanner is present");
      expect(qrScanner, findsOneWidget);

      final manUalIDButton = find.widgetWithText(ElevatedButton, "Manual ID Entry");

      Config.log.i("Manual ID Entry button is present");
      expect(manUalIDButton, findsOneWidget);

      await tester.tap(manUalIDButton);
      await tester.pumpAndSettle();

      final inputIDForm = find.widgetWithText(AlertDialog, "ID");
      Config.log.i("the ID entry pop up is present");
      expect(inputIDForm, findsOneWidget);

      final idInputFields = find.widgetWithIcon(TextFormField, Icons.perm_identity);
      Config.log.i("the ID entry pop up is present");
      expect(idInputFields, findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, "Cancel");
      final submitButton = find.widgetWithText(ElevatedButton, "Submit");

      Config.log.i("The buttons for ID Input Dialog are present");
      expect(cancelButton, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));
    });
  });
}