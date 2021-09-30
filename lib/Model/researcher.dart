
import 'package:plate_waste_recorder/Model/researcher_info.dart';

class Researcher{
  String _researcherName;
  List<String> _researchGroupInfos = [];

  Researcher(this._researcherName);

  ResearcherInfo getResearcherInfo(){
    return ResearcherInfo(this._researcherName);
  }




}