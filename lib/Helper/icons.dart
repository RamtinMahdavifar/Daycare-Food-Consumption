import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category {
  String name;
  IconData icon;

  Category(this.name, this.icon);
}

List<Category> categories = [
  Category('Food', Icons.fastfood),
  Category('Input Data', Icons.drive_file_rename_outline),
  Category('Roster', Icons.view_list),
  Category('View Data', Icons.pageview),

];