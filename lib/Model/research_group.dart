import 'dart:convert';
<<<<<<< HEAD

=======
import 'package:plate_waste_recorder/Helper/config.dart';
>>>>>>> Development
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

/// class representing a research group, institutions, research data etc is
/// stored within a particular research group, research groups can be created
/// by one owner who can then invite others to the research group via invite code
class ResearchGroup{
<<<<<<< HEAD
  String _groupName;
  ResearcherInfo _groupOwner;
=======
  late String _groupName;
  late ResearcherInfo _groupOwner;
>>>>>>> Development

  // groupMembers will only include members of the group outside of the owner
  // ie the owner of the group isn't included in this list
  List<ResearcherInfo> _groupMembers = []; // TODO: change datatype to Map<String dbkeys, ResearcherInfo>

  // keys consist of String database keys for each InstitutionInfo value
  Map<String,InstitutionInfo> _institutionsMap = Map();

  // ResearchGroup constructor
<<<<<<< HEAD
  ResearchGroup(this._groupName, this._groupOwner);
=======
  ResearchGroup(String groupName, ResearcherInfo groupOwner){
    assert(groupName.isNotEmpty);
    // ensure the owner of this group has legitimate data
    assert(groupOwner.name.isNotEmpty);
    assert(groupOwner.databaseKey.isNotEmpty);
    this._groupOwner = groupOwner;
    this._groupName = groupName;
  }
>>>>>>> Development

  String get name{
    return this._groupName;
  }

  ResearcherInfo get owner{
    return this._groupOwner;
  }

  set name(String newName){
<<<<<<< HEAD
=======
    assert(newName.isNotEmpty);
>>>>>>> Development
    this._groupName = newName;
  }

  set owner(ResearcherInfo newOwner){
<<<<<<< HEAD
    this._groupOwner = newOwner;
  }

  void addNewInstitution(InstitutionInfo institutionInfo){
=======
    // ensure the new owner has legitimate data
    assert(newOwner.name.isNotEmpty);
    assert(newOwner.databaseKey.isNotEmpty);
    Config.log.i("setting research group: " + this.name + "'s owner to: " + newOwner.name);
    this._groupOwner = newOwner;
  }

  /// adds the input InstitutionInfo object to this research group,
  /// Preconditions: institutionInfo.name.isNotEmpty && institutionInfo.databaseKey.isNotEmpty
  /// Postconditions: institutionInfo is stored locally under this research group
  void addNewInstitution(InstitutionInfo institutionInfo){
    // ensure the institution added has legitimate data
    assert(institutionInfo.name.isNotEmpty);
    assert(institutionInfo.databaseKey.isNotEmpty);
    Config.log.i("adding institution: " + institutionInfo.name + " to researchGroup" + this._groupName);
>>>>>>> Development
    this._institutionsMap[institutionInfo.databaseKey] = institutionInfo;
    // TODO: synchronize this with the database so when an institution is added
    // TODO: to a research group it is put on the database as well
  }

<<<<<<< HEAD
  Map<String,InstitutionInfo> get institutionsMap{
    return this._institutionsMap;
  }
  
  ResearchGroupInfo getResearchGroupInfo(){
=======
  /// returns a Map<String,InstitutionInfo> such that the keys of this map are the
  /// database keys of each InstitutionInfo value, ie if x is an InstitutionInfo value,
  /// it must be that institutionsMap[x.databaseKey] = x
  /// Preconditions: None
  /// Postconditions: returns a map whose format is described above, if the research group
  /// doesn't have any InstitutionInfos stored, an empty map is returned
  Map<String,InstitutionInfo> get institutionsMap{
    return this._institutionsMap;
  }

  /// returns a ResearchGroupInfo object whose name and databaseKey fields are this._groupName
  /// Preconditions: this._groupName.isNotEmpty
  /// Postconditions: returns a ResearchGroupInfo object described above
  ResearchGroupInfo getResearchGroupInfo(){
    // make sure this object has a valid name before creating this info
    assert(this._groupName.isNotEmpty);
>>>>>>> Development
    return ResearchGroupInfo(this._groupName);
  }

  Map<String, dynamic> toJson() => {
    '_groupName': this._groupName,
    '_groupOwner': jsonEncode(this._groupOwner),
    '_groupMembers': jsonEncode(this._groupMembers),
    '_institutionsMap': jsonEncode(this._institutionsMap)
  };

  ResearchGroup.fromJSON(Map<String, dynamic> json)
<<<<<<< HEAD
      : _groupName = json["_groupName"].toString(), _groupOwner = ResearcherInfo.fromJSON(json["_groupOwner"]),
=======
      : _groupName = json["_groupName"].toString(), _groupOwner = ResearcherInfo.fromJSON(json["_groupOwner"]as Map<String,dynamic>),
>>>>>>> Development
        _groupMembers = (json["_groupMembers"] as List).cast<ResearcherInfo>(),
        // look inside of the _institutionsMap field, this is originally a Map<String,dynamic> and
        // must be converted to a map of <String,InstitutionInfo>, casting will not work
        // here, we need to recreate each InstitutionInfo from the json itself, these
        // are the values of the map, we can reuse the keys already in the json.
        _institutionsMap = Map<String,InstitutionInfo>.fromIterables((json["_institutionsMap"] as Map<String,dynamic>).keys,
            (json["_institutionsMap"] as Map<String,dynamic>).values.map(
<<<<<<< HEAD
                (institutionJSON)=>InstitutionInfo.fromJSON(institutionJSON)).toList());
=======
                (institutionJSON)=>InstitutionInfo.fromJSON(institutionJSON as Map<String, dynamic>)).toList());
>>>>>>> Development
}