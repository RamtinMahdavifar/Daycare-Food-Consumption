import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/qr_scan_id.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:plate_waste_recorder/Model/food_status.dart';
import '../mocks/institution_info_mock.dart';

void main() {
  group("Scan QR Code Tests",() {

    final InstitutionInfoMock currentInstitutionMock = InstitutionInfoMock();

    Config.log.i("Build our app and trigger a frame.");
    testWidgets('scan qr code ui test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home:  QR_ScanID(currentInstitutionMock, FoodStatus.eaten )));

      Config.log.i("Testing Components - QR Scanner");
      final openQRScannerButton = find.byType(QRView);
      expect(openQRScannerButton, findsOneWidget);

    });
  });
}