import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'dart:convert';
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';

import 'meal_info.dart';

/// Class to a access the firebase database, this class is implemented using the
/// singleton pattern and provides methods to read and write data to and from
/// Firebase
class Database {
  // private instance of our firebase database
  static final FirebaseDatabase _databaseInstance = FirebaseDatabase.instance;

  // initialize the singleton instance of our Database class
  static final Database _instance = Database._privateConstructor();

  // initialize the location research groups are to be stored on the database
  final String _RESEARCHGROUPROOTLOCATION = "Research Groups";

  // initialize the constant location where we store institution infos for a particular
  // research group
  final String _RESEARCHGROUPINSTITUTIONSLOCATION = "_institutionsMap";

  // initialize the location we store more specific data for particular research groups
  final String _RESEARCHGROUPDATALOCATION = "Research Group Data";

  // initialize the location we store institution objects at, an institution may be
  // stored at: _RESEARCHGROUPDATALOCATION/particular research group/_INSTITUTIONSDATALOCATION
  final String _INSTITUTIONSDATALOCATION = "Institutions";

  // initialize the location we store Subject objects at, a subject may be stored at
  // _RESEARCHGROUPDATALOCATION/particular research group/_SUBJECTSDATALOCATION/particular institution
  final String _SUBJECTSDATALOCATION = "Institution Subjects";

  // initialize the location we store Meal objects at, a meal may be stored at
  // _RESEARCHGROUPDATALOCATION/particular research group/_MEALSDATALOCATION/ each
  // meal has a unique id assigned to it when written to the database, as such we don't
  // need to store meals relative to some subject
  final String _MEALSDATALOCATION = "Subject Meals";

  // define a private constructor for this class which will allocate memory etc
  // to class, this is only call-able from within this class.
  Database._privateConstructor();

  // define a factory constructor for this class, this constructor can be called
  // as Database(), this constructor is the only non-private constructor for this
  // class, so this is the only way this class can be instantiated from outside
  // of this class, this ensures that there is only one instance of our database
  // at once
  factory Database() {
    return _instance;
  }

  void addInstitutionToResearchGroup(Institution institution, ResearchGroupInfo currentResearchGroupInfo){
    InstitutionInfo currentInstitutionInfo = institution.getInstitutionInfo();
    DatabaseReference institutionReference = _databaseInstance.reference()
        .child(this._RESEARCHGROUPROOTLOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(this._RESEARCHGROUPINSTITUTIONSLOCATION)
        .child(currentInstitutionInfo.databaseKey);

    // since we are storing this institution for a research group, only write
    // an InstitutionInfo to the database, convert this InstitutionInfo to JSON

    String institutionInfoJSON = jsonEncode(currentInstitutionInfo);

    // convert the produced JSON to a map which can be stored on our database
    Map<String, dynamic> institutionInfoMap = json.decode(institutionInfoJSON);
    institutionReference.set(institutionInfoMap);
  }

  // TODO: update to make async
  void readInstitution(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo,
        Function(Institution) callback){
    DatabaseReference desiredInstitutionReference = _databaseInstance.reference()
        .child(this._RESEARCHGROUPROOTLOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(institutionInfo.databaseKey);
    desiredInstitutionReference.once().then((DataSnapshot dataSnapshot)=>(
        callback(
            Institution.fromJSON(jsonDecode(dataSnapshot.value.toString()))
        )
    ));
  }

  // TODO: update to make async
  void readResearchGroup(ResearchGroupInfo researchGroupInfo,
      Function(ResearchGroup) callback){
    DatabaseReference desiredResearchGroupReference = _databaseInstance.reference()
        .child(this._RESEARCHGROUPROOTLOCATION)
        .child(researchGroupInfo.databaseKey);
    // use onValue instead of once() to read data here as we want to read data and
    // then also update data if any changes have occurred to the database
    desiredResearchGroupReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic> researchGroupJSON = jsonDecode(dataSnapshot.value.toString());
      ResearchGroup retrievedResearchGroup = ResearchGroup.fromJSON(researchGroupJSON);
      callback(retrievedResearchGroup);
    });
  }

  Stream<Event> getResearchGroupStream(ResearchGroupInfo researchGroupInfo){
    DatabaseReference desiredResearchGroupReference = _databaseInstance.reference()
        .child(this._RESEARCHGROUPROOTLOCATION)
        .child(researchGroupInfo.databaseKey);
    return desiredResearchGroupReference.onValue;
  }

  void writeResearchGroup(ResearchGroup researchGroup){
    ResearchGroupInfo researchGroupInfo = researchGroup.getResearchGroupInfo();
    DatabaseReference researchGroupDatabaseReference = _databaseInstance.reference()
        .child(this._RESEARCHGROUPROOTLOCATION)
        .child(researchGroupInfo.databaseKey);
    // convert the ResearchGroup object to JSON before writing to the db, this also
    // converts fields and data structures within this object to JSON
    String researchGroupJSON = jsonEncode(researchGroup);
    // we cannot write raw JSON to the database, decode this JSON to get a map which
    // preserves the structure of our object when written to the database
    Map<String, dynamic> researchGroupAsMap = json.decode(researchGroupJSON);
    researchGroupDatabaseReference.set(researchGroupAsMap);
  }

  void writeSubjectMeal(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo,
      SubjectInfo currentSubject, Meal currentMeal){
    // ensure that the input Info objects do not have empty database keys
    // each input Info is created with null safety so properties can never be null
    assert(institutionInfo.databaseKey.isNotEmpty);
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    assert(currentSubject.databaseKey.isNotEmpty);

    // TODO: finish implementation
    MealInfo currentMealInfo = currentMeal.getMealInfo();
    // ensure the MealInfo we write to the database for this subject
    assert(currentMealInfo.databaseKey.isNotEmpty);
    assert(currentMealInfo.name.isNotEmpty);
  }
}