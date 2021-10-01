import 'dart:convert';

import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

/// class representing a research group, institutions, research data etc is
/// stored within a particular research group, research groups can be created
/// by one owner who can then invite others to the research group via invite code
class ResearchGroup{
  String _groupName;
  ResearcherInfo _groupOwner;

  // groupMembers will only include members of the group outside of the owner
  // ie the owner of the group isn't included in this list
  List<ResearcherInfo> _groupMembers = []; // TODO: change datatype to Map<String dbkeys, ResearcherInfo>

  // keys consist of String database keys for each InstitutionInfo value
  Map<String,InstitutionInfo> _institutionsMap = Map();

  // ResearchGroup constructor
  ResearchGroup(this._groupName, this._groupOwner);

  String get name{
    return this._groupName;
  }

  ResearcherInfo get owner{
    return this._groupOwner;
  }

  List<ResearcherInfo> get members{
    return this._groupMembers;
  }


  set name(String newName){
    this._groupName = newName;
  }

  set owner(ResearcherInfo newOwner){
    this._groupOwner = newOwner;
  }

  void addNewMember(ResearcherInfo newMember){

    this._groupMembers.add(newMember);
  }

  int removeMember(ResearcherInfo member){

    if(this._groupMembers.contains(member)){
      this._groupMembers.remove(member);
      // TODO: remove integer return codes and use exception instead if member isn't in list

      return 0;
    }else return -1;

  }

  void addNewInstitution(InstitutionInfo institutionInfo){
    this._institutionsMap[institutionInfo.databaseKey] = institutionInfo;
    // TODO: synchronize this with the database so when an institution is added
    // TODO: to a research group it is put on the database as well
  }

  Map<String,InstitutionInfo> get institutionsMap{
    return this._institutionsMap;
  }
  
  ResearchGroupInfo getResearchGroupInfo(){
    return ResearchGroupInfo(this._groupName);
  }

  Map<String, dynamic> toJson() => {
    '_groupName': this._groupName,
    '_groupOwner': this._groupOwner,
    '_groupMembers': this._groupMembers,
    '_institutionsMap': this._institutionsMap
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

  // TODO: need null checks here, ie what if there aren't any group members so that field isn't even stored on the db
}