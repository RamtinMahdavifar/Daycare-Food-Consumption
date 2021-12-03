import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

String? FOODNAME;
String? WEIGHT;
String? COMMENTS;
String? SubjectID;
String? INSTITUTE;
String? STATUS;
String? DATE;
List<String?> CONTAINERS = [];

void setFoodVars(String? foodName, String? weight, String? comments){
  FOODNAME = foodName;
  WEIGHT = weight;
  COMMENTS = comments;
  print("FOOD DATA ENTERED!");

}

void setIDVar(String? id){
  SubjectID = id;
  Config.log.i("ID SET: $SubjectID");
}

void setInstituteVar(String? institute){
  INSTITUTE = institute;
  Config.log.i("INSTITUTION SET: $INSTITUTE");
}

void setStatusVar(String? status){
  STATUS = status;
  print("STATUS SET");
}

void setDATE(){
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DATE = formatter.format(now);
  Config.log.i("DATE SET: ${DATE.toString()}");
}

void addContainer(String? preset){
  CONTAINERS.add(preset);
  print("ADDED NEW CONTAINER");
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
  return SubjectID;
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