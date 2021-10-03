
import 'package:plate_waste_recorder/Model/info.dart';

/// Class with information related to a ResearchGroup, can be used to display some
/// high level information about a ResearchGroup or read a ResearchGroup in from
/// our database
class ResearchGroupInfo extends Info{
  // must override these fields here or else fields cannot be used in the JSON constructor
  String name = "";
  String databaseKey = "";

  ResearchGroupInfo(String name){
    this.name = name;
    this.databaseKey = name;
  }

  // this is considered a constructor and so cannot be inherited from our super Info
  ResearchGroupInfo.fromJSON(Map<String, dynamic> json)
      : name = json["name"].toString(),
        databaseKey = json["databaseKey"];
}