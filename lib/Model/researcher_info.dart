
import 'package:plate_waste_recorder/Model/info.dart';

/// Class storing high level information regarding researchers, can be used to display
/// such high level information or read in a Researcher object from our database
class ResearcherInfo extends Info{
  // we must override these fields here or else they are inaccessible in JSON constructor
  String name = "";
  String databaseKey = "";

  ResearcherInfo(String name){
<<<<<<< HEAD
=======
    assert(name.isNotEmpty);
>>>>>>> Development
    this.name = name;
    this.databaseKey = name;
  }

  // this is considered a constructor and so cannot be inherited from our super Info
  ResearcherInfo.fromJSON(Map<String, dynamic> json)
      : name = json["name"].toString(),
<<<<<<< HEAD
        databaseKey = json["databaseKey"];
=======
        databaseKey = json["databaseKey"] as String;
>>>>>>> Development


}