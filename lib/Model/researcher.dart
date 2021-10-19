
import 'dart:convert';

import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';

/// Class representing a researcher, a researcher is considered either a higher level
/// administrative personnel who might be extracting and interpreting data collected
/// or research assistants who collect the actual data
class Researcher{
  String _researcherName;
  List<ResearchGroupInfo> _researchGroupInfos = [];

  Researcher(this._researcherName);


  /// returns a ResearcherInfo object whose name and databaseKey fields are this._researcherName
  /// Preconditions: this._researcherName.isNotEmpty
  /// Postconditions: returns a ResearcherInfo object described above
  ResearcherInfo getResearcherInfo(){
    // ensure this object has a legitimate name before creating this info
    assert(this._researcherName.isNotEmpty);
    return ResearcherInfo(this._researcherName);
  }

  Map<String, dynamic> toJson() => {
    '_researcherName': this._researcherName,
    '_researchGroupInfos': jsonEncode(this._researchGroupInfos),
  };




}