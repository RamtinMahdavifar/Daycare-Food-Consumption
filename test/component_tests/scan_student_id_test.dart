import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/id_input_page.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import '../mocks/institution_info_mock.dart';

void main() {
  group("Scan Student ID Component Tests",() {

    final InstitutionInfoMock currentInstitutionMock = InstitutionInfoMock();

    testWidgets('scan student ID page - scan - tests', (WidgetTester tester) async {
      Config.log.i("Build our app and trigger a frame.");
      await tester.pumpWidget(MaterialApp(
        home: ID_InputPage(currentInstitutionMock, FoodStatus.eaten),
      ));
      Config.log.i("Component Testing - scan student ID page - scan");

      final studentIDScanner = find.text("Scan a Student ID");

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));

      final qrScanner = find.byType(QRView);

      Config.log.i("QR Scanner is present");
      expect(qrScanner, findsOneWidget);
    });

    testWidgets('scan student ID page - manual tests', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: ID_InputPage(currentInstitutionMock, FoodStatus.eaten),
      ));
      Config.log.i("Component Testing - scan student ID page - manual");

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

      final studentIDScanner = find.text("Scan a Student ID");

      Config.log.i("Scan Student ID page header is present");
      expect(studentIDScanner, findsNWidgets(2));
    });
  });
}