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
  List<ResearcherInfo> _groupMembers = [];

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

      return 0;
    }else return -1;

  }
  
  ResearchGroupInfo getResearchGroupInfo(){
    return ResearchGroupInfo(this._groupName);
  }
  
  ResearchGroup.fromJSON(Map<String, dynamic> json)
      : _groupName = json["_groupName"].toString(), _groupOwner = json["_groupOwner"],
        _groupMembers = json["_groupMembers"]; // TODO: need null checks here, ie what if there aren't any group members so that field isn't even stored on the db
}