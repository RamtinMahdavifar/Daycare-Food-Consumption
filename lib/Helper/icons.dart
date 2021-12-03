import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  ///Category class to hold the icons and their string names
  ///this class is used to pass different icons between the same button widget

  String name; // Name of icon
  IconData icon; //icon object

  Category(this.name, this.icon);
}
///developer can call the below dictionary in any file to pass the icon value
///Also to add new icon value just and new category object in the class
///the index of the List start @ 0 so Category[0] will be for Food

List<Category> categories = [ //list to store all the icon with their respective names
  Category('Food', Icons.fastfood),
  Category('Input Data', Icons.drive_file_rename_outline),
  Category('Roster', Icons.view_list),
  Category('View Data', Icons.pageview),
];
