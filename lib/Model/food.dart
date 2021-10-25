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

class FoodBank{

  static final List<String> foods = [];
  static void getFoodNames() async{

    File f = File("/food_names.csv");


    final input = f.openRead();
    final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
    foods.add(fields.toString());
    print("Fields added");
    print(fields);

  }





  //final foods = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
  //assert(foods.toString() == [[',b', 3.1, 42], ['n\n']].toString());
 /* static final List<String> foods = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];*/

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(foods);
    print("foods");
    print(foods);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}