import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/researcher.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';

/// class representing a research group, institutions, research data etc is
/// stored within a particular research group, research groups can be created
/// by one owner who can then invite others to the research group via invite code
class ResearchGroup{
  String _groupName;
  ResearcherInfo _groupOwner;

  // groupMembers will only include members of the group outside of the owner
  // ie the owner of the group isn't included in this list
  List<ResearcherInfo> _groupMembers = [];


  ResearchGroup(this._groupName, this._groupOwner);


}