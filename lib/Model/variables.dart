import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? FOODNAME;
String? WEIGHT;
String? COMMENTS;
String? ID;
String? INSTITUTE;
String? STATUS;
String? DATE;

void setFoodVars(String? foodName, String? weight, String? comments){
  FOODNAME = foodName;
  WEIGHT = weight;
  COMMENTS = comments;
  print("FOOD DATA ENTERED!");

}

void setIDVar(String? id){
  ID = id;
  print("ID SET");
}

void setInstituteVar(String? institute){
  INSTITUTE = institute;
  print("INSTITUTION SET");
}

void setStatusVar(String? status){
  STATUS = status;
  print("STATUS SET");
}

void setDATE(){
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DATE = formatter.format(now);
  print("DATE SET");
}

String? getFoodName(){
  return FOODNAME;
}

String? getWeight(){
  return WEIGHT;
}

String? getComments(){
  return COMMENTS;
}

String? getID(){
  return ID;
}

String? getStatus(){
  return STATUS;
}

String? getInst(){
  return INSTITUTE;
}

String? getDATE(){
  return DATE;
}