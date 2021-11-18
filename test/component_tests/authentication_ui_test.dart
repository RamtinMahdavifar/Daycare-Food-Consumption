import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_waste_recorder/View/login_page.dart';


//This file right now is only a placeholder for authentication tests
void main() {
  group("Authentication Component Tests",() {
    testWidgets('login page ui test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: LoginPage(),
      ));

      final pageHeader = find.text("Plate Waste Tracker");

      //verify the header is correct
      expect(pageHeader, findsOneWidget);
    });
  });
}