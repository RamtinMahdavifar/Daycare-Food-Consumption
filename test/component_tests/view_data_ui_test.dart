import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/View/view_data_page.dart';

void main() {
  group("View Data Component Tests",() {
      testWidgets('view data from institution page tests', (WidgetTester tester) async {
        Config.log.i("Build our app and trigger a frame.");
        await tester.pumpWidget(MaterialApp(
          home: ViewDataPage("U of S", "Campus Drive"),
        ));

        Config.log.i("Component Test - view data from institution page tests");
        final viewDataPageHeader = find.text("View Data For Institution: U of S");

        Config.log.i("Check the header is presented correctly");
        expect(viewDataPageHeader, findsOneWidget);

        final scanQRCodeBtn = find.widgetWithText(Card, "Scan QR Code");
        final selectFromRosterBtn = find.widgetWithText(Card, "Select From Roster");
        final exportDataBtn = find.widgetWithText(Card, "Export Data");

        Config.log.i("Check the buttons in the page are presented correctly");
        expect(scanQRCodeBtn, findsOneWidget);
        expect(selectFromRosterBtn, findsOneWidget);
        expect(exportDataBtn, findsOneWidget);
      });
  });
}