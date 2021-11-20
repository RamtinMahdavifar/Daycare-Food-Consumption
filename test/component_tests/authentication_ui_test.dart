import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:googleapis/chat/v1.dart';
import 'package:plate_waste_recorder/View/login_page.dart';
import 'package:plate_waste_recorder/Helper/config.dart';


//This file right now is only a placeholder for authentication tests
void main() {
  group("Component Testing - Authentication",() {
    testWidgets('login page ui test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
      ));
      // Component Logging
      Config.log.i("Component Testing - Authentication page");

      //verify the header is correct
      Config.log.i("Testing - page header present on login page");
      final pageHeader = find.text("Plate Waste Tracker");
      expect(pageHeader, findsOneWidget);

      // Verify google button is present
      // Config.log.i("Testing - google login button present on login page");
      // final googleButton = find.text("Google");
      // expect(googleButton,findsOneWidget);
    });
  });
}