
import 'package:plate_waste_recorder/Model/info.dart';

class ResearcherInfo extends Info{
  // we must override these fields here or else they are inaccessible in JSON constructor
  String name = "";
  String databaseKey = "";

  ResearcherInfo(String name){
    this.name = name;
    this.databaseKey = name;
  }

  // this is considered a constructor and so cannot be inherited from our super Info
  ResearcherInfo.fromJSON(Map<String, dynamic> json)
      : name = json["name"].toString(),
        databaseKey = json["databaseKey"];


}