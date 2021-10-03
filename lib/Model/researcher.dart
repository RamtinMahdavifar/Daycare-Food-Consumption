
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';

/// Class representing a researcher, a researcher is considered either a higher level
/// administrative personnel who might be extracting and interpreting data collected
/// or research assistants who collect the actual data
class Researcher{
  String _researcherName;
  List<ResearchGroupInfo> _researchGroupInfos = [];

  Researcher(this._researcherName);

  ResearcherInfo getResearcherInfo(){
    return ResearcherInfo(this._researcherName);
  }

  Map<String, dynamic> toJson() => {
    '_researcherName': this._researcherName,
    // TODO: somehow convert list to JSON
    '_researchGroupInfos': this._researchGroupInfos,
  };




}