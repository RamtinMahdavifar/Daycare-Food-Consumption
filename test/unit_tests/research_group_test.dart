import 'dart:convert';

import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:test/test.dart';
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'package:plate_waste_recorder/Model/researcher_info.dart';
// run tests from the terminal using: flutter test test/research_group_test.dart
// if flutter.bat is not part of you PATH environment variable provide the absolute path
// to flutter.bat, for example use installationdirectory\flutter\bin\flutter test test/research_group_test.dart
void main(){
  group("research_group getters and setters",() {
    test("research group getters", () {

      final groupOwner = ResearcherInfo("Prof");

      final testResearchGroup = ResearchGroup("Test rGroup", groupOwner);

      expect(testResearchGroup.name,"Test rGroup");
      expect(testResearchGroup.owner, groupOwner);

      expect(testResearchGroup.getResearchGroupInfo(), ResearchGroupInfo("Test rGroup"));

      testResearchGroup.addNewInstitution(InstitutionInfo("test institution", "institution address"));

      expect(testResearchGroup.institutionsMap, <String,InstitutionInfo>{
        "institution address":InstitutionInfo("test institution","institution address")});

      testResearchGroup.addNewInstitution(InstitutionInfo("other institution", "other address"));
      expect(testResearchGroup.institutionsMap, <String,InstitutionInfo>{
      "institution address":InstitutionInfo("test institution","institution address"),
      "other address":InstitutionInfo("other institution","other address")});

    });

    test("research group setters", () {

      final groupOwner = ResearcherInfo("Prof");
      final groupOwner1 = ResearcherInfo("Student1");

      final testResearchGroup = ResearchGroup("Test rGroup", groupOwner);

      testResearchGroup.name = "new test name";
      testResearchGroup.owner = groupOwner1;
      expect(testResearchGroup.name, "new test name");
      expect(testResearchGroup.owner, groupOwner1);
    });
  });

  group("JSON operations",(){
    test("to json",(){
      final groupOwner = ResearcherInfo("Prof");
      final testResearchGroup = ResearchGroup("Test rGroup", groupOwner);

      expect(testResearchGroup.toJson(),<String,dynamic>{"_groupName":"Test rGroup","_groupOwner":jsonEncode(groupOwner),
      "_groupMembers":"[]","_institutionsMap":"{}"});
    });

    test("from json",(){
      ResearcherInfo groupOwner = ResearcherInfo("Prof");

      Map<String,dynamic> testJson = <String,dynamic>{"_groupName":"Test rGroup","_groupOwner":
      groupOwner.toJson(), "_groupMembers":[],"_institutionsMap":<String,InstitutionInfo>{}};

      ResearchGroup testResearchGroup = ResearchGroup.fromJSON(testJson);
      expect(testResearchGroup.name,"Test rGroup");
      expect(testResearchGroup.owner,groupOwner);
      expect(testResearchGroup.institutionsMap,<String,InstitutionInfo>{});
    });
  });
}