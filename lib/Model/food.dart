import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future<void>.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {
        'name': query + index.toString(),
        'price': Random().nextInt(100).toString()
      };
    });
  }
}

class FoodBank {

 static final List<String> foods = [
    'Apple',
    'Banana',
    'Fruit Gushers',
    'Steak',
    'Mac and Cheese',
    'Hot Dog',
    'Fruit roll up',
    'Oreos',
    'Orange Juice',
    'Apple Juice',
    'Dog Food',
    'my sanity',
    'peanut butter sandwich',
  ];


  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(foods);
    //print("foods");
    //print(foods);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}