import 'dart:convert';

import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

/// class representing a research group, institutions, research data etc is
/// stored within a particular research group, research groups can be created
/// by one owner who can then invite others to the research group via invite code
class ResearchGroup{
  late String _groupName;
  late ResearcherInfo _groupOwner;

  // groupMembers will only include members of the group outside of the owner
  // ie the owner of the group isn't included in this list
  List<ResearcherInfo> _groupMembers = []; // TODO: change datatype to Map<String dbkeys, ResearcherInfo>

  // keys consist of String database keys for each InstitutionInfo value
  Map<String,InstitutionInfo> _institutionsMap = Map();

  // ResearchGroup constructor
  ResearchGroup(String groupName, ResearcherInfo groupOwner){
    assert(groupName.isNotEmpty);
    // ensure the owner of this group has legitimate data
    assert(groupOwner.name.isNotEmpty);
    assert(groupOwner.databaseKey.isNotEmpty);
    this._groupOwner = groupOwner;
    this._groupName = groupName;
  }

  String get name{
    return this._groupName;
  }

  ResearcherInfo get owner{
    return this._groupOwner;
  }

  set name(String newName){
    assert(newName.isNotEmpty);
    this._groupName = newName;
  }

  set owner(ResearcherInfo newOwner){
    // ensure the new owner has legitimate data
    assert(newOwner.name.isNotEmpty);
    assert(newOwner.databaseKey.isNotEmpty);
    this._groupOwner = newOwner;
  }

  void addNewInstitution(InstitutionInfo institutionInfo){
    // ensure the institution added has legitimate data
    assert(institutionInfo.name.isNotEmpty);
    assert(institutionInfo.databaseKey.isNotEmpty);
    this._institutionsMap[institutionInfo.databaseKey] = institutionInfo;
    // TODO: synchronize this with the database so when an institution is added
    // TODO: to a research group it is put on the database as well
  }

  Map<String,InstitutionInfo> get institutionsMap{
    return this._institutionsMap;
  }
  
  ResearchGroupInfo getResearchGroupInfo(){
    // make sure this object has a valid name before creating this info
    assert(this._groupName.isNotEmpty);
    return ResearchGroupInfo(this._groupName);
  }

  Map<String, dynamic> toJson() => {
    '_groupName': this._groupName,
    '_groupOwner': jsonEncode(this._groupOwner),
    '_groupMembers': jsonEncode(this._groupMembers),
    '_institutionsMap': jsonEncode(this._institutionsMap)
  };

  ResearchGroup.fromJSON(Map<String, dynamic> json)
      : _groupName = json["_groupName"].toString(), _groupOwner = ResearcherInfo.fromJSON(json["_groupOwner"]),
        _groupMembers = (json["_groupMembers"] as List).cast<ResearcherInfo>(),
        // look inside of the _institutionsMap field, this is originally a Map<String,dynamic> and
        // must be converted to a map of <String,InstitutionInfo>, casting will not work
        // here, we need to recreate each InstitutionInfo from the json itself, these
        // are the values of the map, we can reuse the keys already in the json.
        _institutionsMap = Map<String,InstitutionInfo>.fromIterables((json["_institutionsMap"] as Map<String,dynamic>).keys,
            (json["_institutionsMap"] as Map<String,dynamic>).values.map(
                (institutionJSON)=>InstitutionInfo.fromJSON(institutionJSON)).toList());
}