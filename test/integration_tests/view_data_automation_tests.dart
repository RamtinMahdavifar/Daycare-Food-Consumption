import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Roster Automation Tests",() {
    testWidgets("Select the Roster Buttons", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final firstInstitution = find.bySemanticsLabel("test");
      await tester.tap(firstInstitution);
      await tester.pumpAndSettle();

      Config.log.i("Find buttons on page");
      //Check all button widgets in institution page are presented
      final rosterButton = find.text("Roster");
      final presetButton = find.text("Preset");
      final viewDataButton = find.text("View Data");
      final inputDataButton = find.text("Input Data");
      expect(rosterButton, findsOneWidget);
      expect(presetButton, findsOneWidget);
      expect(viewDataButton, findsOneWidget);
      expect(inputDataButton, findsOneWidget);

      Config.log.i("Tap view data button");
      await tester.tap(viewDataButton);
      await tester.pumpAndSettle();

      final backButton = find.byIcon(Icons.arrow_back);

      expect(backButton, findsOneWidget);

      Config.log.i("Tap the back button on the View data page");
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      Config.log.i("Tap view data button again");
      await tester.tap(viewDataButton);
      await tester.pumpAndSettle();

      final scanButton = find.text("Scan QR Code");
      final selectButton = find.text("Select From Roster");
      final exportButton = find.text("Export Data");

      Config.log.i("Tap find the buttons on the view data page");
      expect(scanButton, findsOneWidget);
      expect(selectButton, findsOneWidget);
      expect(exportButton, findsOneWidget);
      
      Config.log.i("Tap the Scan QR Code Button");
      await tester.tap(scanButton);
      await tester.pumpAndSettle();

      Config.log.i("Tap the Select from Roster Button");
      await tester.tap(selectButton);
      await tester.pumpAndSettle();
      
    });
  });
}