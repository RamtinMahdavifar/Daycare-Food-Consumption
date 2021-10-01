import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'dart:convert';
import 'package:plate_waste_recorder/Model/research_group.dart';

/// Class to a access the firebase database, this class is implemented using the
/// singleton pattern and provides methods to read and write data to and from
/// Firebase
class Database {
  // private instance of our firebase database
  static final FirebaseDatabase _databaseInstance = FirebaseDatabase.instance;

  // initialize the singleton instance of our Database class
  static final Database _instance = Database._privateConstructor();

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

  void writeInstitution(Institution institution, ResearchGroupInfo currentResearchGroupInfo){
    InstitutionInfo currentInstitutionInfo = institution.getInstitutionInfo();
    DatabaseReference institutionReference = _databaseInstance.reference()
        .child(currentResearchGroupInfo.databaseKey)
        .child(currentInstitutionInfo.databaseKey);
    institutionReference.set(institution);
  }

  void readInstitution(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo,
        Function(Institution) callback){
    DatabaseReference desiredInstitutionReference = _databaseInstance.reference()
        .child(currentResearchGroupInfo.databaseKey)
        .child(institutionInfo.databaseKey);
    desiredInstitutionReference.once().then((DataSnapshot dataSnapshot)=>(
        callback(
            Institution.fromJSON(jsonDecode(dataSnapshot.value.toString()))
        )
    ));
  }

  void readResearchGroup(ResearchGroupInfo researchGroupInfo,
      Function(ResearchGroup) callback){
    DatabaseReference desiredResearchGroupReference = _databaseInstance.reference()
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
        .child(researchGroupInfo.databaseKey);
    return desiredResearchGroupReference.onValue;
  }

  void writeResearchGroup(ResearchGroup researchGroup){
    ResearchGroupInfo researchGroupInfo = researchGroup.getResearchGroupInfo();
    DatabaseReference researchGroupDatabaseReference = _databaseInstance.reference()
      .child(researchGroupInfo.databaseKey);
    researchGroupDatabaseReference.set(researchGroup);
  }
}