import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';



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

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}