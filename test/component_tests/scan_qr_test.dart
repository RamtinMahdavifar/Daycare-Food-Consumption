import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/qrcode.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


void main() {
  group("Scan QR Code Tests",() {
    testWidgets('scan qr code ui test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home:  MyHome()));

      final openQRScannerButton = find.widgetWithText(ElevatedButton,'Open QR Scanner');

      // verify that the Open QR Scanner button widgets appear exactly once in the widget tree.
      expect(find.widgetWithText(ElevatedButton,'Open QR Scanner'), findsOneWidget);

      await tester.tap(openQRScannerButton);
      await tester.pumpWidget(MaterialApp(
          home:  QRViewExample()));

      final pauseButton = find.widgetWithText(ElevatedButton,'pause');
      final resumeButton = find.widgetWithText(ElevatedButton,'resume');
      final qrScannerView = find.byType(QRView);

      //Verify the ui of default qr scanning view
      expect(qrScannerView, findsOneWidget);
      expect(pauseButton, findsOneWidget);
      expect(resumeButton, findsOneWidget);
    });
  });
}