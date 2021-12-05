import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("Roster Automation Tests",() {
    testWidgets("Select an Institution test", (WidgetTester tester) async {
      // app.main();
      // await tester.pumpAndSettle();
      //
      // final firstInstitution = find.text("test");
      // await tester.tap(firstInstitution);
      // await tester.pumpAndSettle();
      //
      // Config.log.i("Select test institution page");
      // // verify that the institution info are presented correctly
      // expect(find.text("Address: test"), findsOneWidget);
      //
      // Config.log.i("Find buttons on page");
      // //Check all button widgets in institution page are presented
      // final rosterButton = find.text("Roster");
      // final presetButton = find.text("Preset");
      // final viewDataButton = find.text("View Data");
      // final inputDataButton = find.text("Input Data");
      //
      // expect(rosterButton, findsOneWidget);
      // expect(presetButton, findsOneWidget);
      // expect(viewDataButton, findsOneWidget);
      // expect(inputDataButton, findsOneWidget);
      //
      // Config.log.i("Tap roster button");
      // await tester.tap(rosterButton);
      // await tester.pumpAndSettle();
      //
      // Config.log.i("Click back icon");
      // final backButton = find.byIcon(Icons.arrow_back);
      // await tester.tap(backButton);
      // await tester.pumpAndSettle();
      //
      // Config.log.i("Tap roster button");
      // await tester.tap(rosterButton);
      // await tester.pumpAndSettle();
      //
      // final deleteButton = find.byIcon(Icons.highlight_remove).first;
      // final qrButton = find.byIcon(Icons.qr_code).first;
      // final editButton = find.byIcon(Icons.mode_edit).first;
      //
      // Config.log.i("Finding roster buttons in roster page");
      // expect(deleteButton, findsNWidgets(1));
      // expect(qrButton, findsNWidgets(1));
      // expect(editButton, findsNWidgets(1));
      //
      // await tester.tap(deleteButton);
      // await tester.pumpAndSettle();
      //
      // await tester.tap(qrButton);
      // await tester.pumpAndSettle();
      //
      // await tester.tap(editButton);
      // await tester.pumpAndSettle();
    });
  });
}