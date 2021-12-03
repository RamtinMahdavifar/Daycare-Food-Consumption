import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:plate_waste_recorder/Helper/config.dart';


void main() {
  group("Scan QR Code Tests",() {
    testWidgets('scan qr code ui test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home:  MyHome("test")));
      Config.log.i("Testing Components - QR Scanner");
      final openQRScannerButton = find.widgetWithText(ElevatedButton,'Open QR Scanner');

      Config.log.i("verify that the Open QR Scanner button widgets appear exactly once in the widget tree");
      expect(find.widgetWithText(ElevatedButton,'Open QR Scanner'), findsOneWidget);

      await tester.tap(openQRScannerButton);
      await tester.pumpWidget(MaterialApp(
          home:  QRViewExample()));

      final pauseButton = find.widgetWithText(ElevatedButton,'pause');
      final resumeButton = find.widgetWithText(ElevatedButton,'resume');
      final qrScannerView = find.byType(QRView);

      //Verify the ui of default qr scanning view
      Config.log.i("Verify QR scanner view is present");
      expect(qrScannerView, findsOneWidget);
      Config.log.i("Verify pause button is present");
      expect(pauseButton, findsOneWidget);
      Config.log.i("Verify resume button is present");
      expect(resumeButton, findsOneWidget);
    });
  });
}