// import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:plate_waste_recorder/Model/authentication.dart';
import 'package:plate_waste_recorder/Model/institution.dart';
import 'package:plate_waste_recorder/Model/meal.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'dart:convert';
import 'package:plate_waste_recorder/Model/research_group.dart';
import 'package:plate_waste_recorder/Model/subject.dart';
import 'package:plate_waste_recorder/Model/subject_info.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'meal_info.dart';
import 'package:flutter/foundation.dart'; // required to check release mode

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

  /// writes the input institution as an InstitutionInfo under the research group specified by the
  /// input ResearchGroupInfo, the input institution is also written in it's entirety to the database in
  /// it's own distinct location, this location is still relative to the input research group
  /// Preconditions: currentResearchGroupInfo.databaseKey.isNotEmpty, institution.getInstitutionInfo().databaseKey.isNotEmpty
  /// Postconditions: writes the input institution as an InstitutionInfo under the research group specified by the
  /// input ResearchGroupInfo, the input institution is also written in it's entirety to the database in
  /// it's own distinct location, this location is still relative to the input research group
  /// if the location specified by the input research group info doesn't
  /// yet exist on the database, it is created.
  void addInstitutionToResearchGroup(Institution institution, ResearchGroupInfo currentResearchGroupInfo){
    // ensure the input researchgroup has a database key
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    InstitutionInfo currentInstitutionInfo = institution.getInstitutionInfo();
    // ensure the input institution has a database key
    assert(currentInstitutionInfo.databaseKey.isNotEmpty);
    DatabaseReference institutionReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing institutionReference
      institutionReference = institutionReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    institutionReference = institutionReference.child(this._RESEARCHGROUPROOTLOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(this._RESEARCHGROUPINSTITUTIONSLOCATION)
        .child(currentInstitutionInfo.databaseKey);

    Config.log.i("writing institution: " + institution.name + " to research group: "
        + currentResearchGroupInfo.name + " on the database");

    // since we are storing this institution for a research group, only write
    // an InstitutionInfo to the database, convert this InstitutionInfo to JSON

    String institutionInfoJSON = jsonEncode(currentInstitutionInfo);

    // convert the produced JSON to a map which can be stored on our database
    Map<String, dynamic> institutionInfoMap = json.decode(institutionInfoJSON) as Map<String,dynamic>;
    institutionReference.set(institutionInfoMap);

    // upon adding an institution to a research group, we want to also store this entire
    // institution to the database in a separate location
    _writeInstitutionToDatabase(institution,currentResearchGroupInfo);
  }

  /// writes the input institution in it's entirety to a location on the database relative to
  /// the research group specified by the input ResearchGroupInfo
  /// Preconditions: currentResearchGroupInfo.databaseKey.isNotEmpty && institution.getInstitutionInfo.databaseKey.isNotEmpty
  /// Postcondition: input institution is written in it's entirety to a location relative to the research
  /// group specified by currentResearchGroupInfo on the database
  /// if the location specified by the input research group info doesn't
  /// yet exist on the database, it is created.
  void _writeInstitutionToDatabase(Institution institution, ResearchGroupInfo currentResearchGroupInfo){
    // make sure research group input has a database key
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    // get the database key of this particular input institution from an institution info
    InstitutionInfo currentInstitutionInfo = institution.getInstitutionInfo();
    // ensure the institution provided has a database key
    assert(currentInstitutionInfo.databaseKey.isNotEmpty);

    DatabaseReference institutionReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing institutionReference
      institutionReference = institutionReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    institutionReference = institutionReference.child(this._RESEARCHGROUPDATALOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(this._INSTITUTIONSDATALOCATION)
        .child(currentInstitutionInfo.databaseKey);

    Config.log.i("Writing institution: " + institution.name + " to the database");

    // convert our Institution Object to json to be written to location institutionReference
    String institutionJSON = jsonEncode(institution);

    // convert the produced JSON to a map which can be stored on our database, storing
    // JSON directly will simply store the JSON as a single string instead of storing
    // each field of our object with it's value as we want
    Map<String, dynamic> institutionMap = json.decode(institutionJSON) as Map<String,dynamic>;
    // write this to the location specified above
    institutionReference.set(institutionMap);
  }


  /// reads in the institution specified by institutionInfo for the research group specified
  /// by currentResearchGroupInfo, executes function callback on the read in institution
  /// Preconditions: institutionInfo.databaseKey.isNotEmpty && currentResearchGroupInfo.databaseKey.isNotEmpty
  /// Postconditions: function callback is executed on the Institution specified by the input
  /// institutionInfo for the research group specified by currentResearchGroupInfo after being read in
  /// from the database
  void readInstitution(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo,
        Function(Institution) callback){
    // ensure the input info objects contain database keys
    assert(institutionInfo.databaseKey.isNotEmpty);
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    Config.log.i("reading institution: " + institutionInfo.name + " from the database using database key " +
    institutionInfo.databaseKey + " for research group: " + currentResearchGroupInfo.name);

    DatabaseReference institutionReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing institutionReference
      institutionReference = institutionReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    institutionReference = institutionReference.child(this._RESEARCHGROUPROOTLOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(institutionInfo.databaseKey);
    institutionReference.once().then((DataSnapshot dataSnapshot)=>(
    // call the input function on the data read from the database
        callback(
            Institution.fromJSON(jsonDecode(dataSnapshot.value.toString()) as Map<String, dynamic>)
        )
    ));
  }


  /// reads the ResearchGroup object specified by the input researchGroupInfo from the database, function
  /// callback is then called using this ResearchGroup as input
  /// Preconditions: researchGroupInfo.databaseKey.isNotEmpty
  /// Postconditions: function callback is executed with input ResearchGroup read in from the database,
  /// this ResearchGroup corresponds to the researchGroupInfo input
  void readResearchGroup(ResearchGroupInfo researchGroupInfo,
      Function(ResearchGroup) callback){
    // ensure the researchgroup passed in has a database key
    assert(researchGroupInfo.databaseKey.isNotEmpty);
    Config.log.i("reading research group: " + researchGroupInfo.name + " from the database using database key: " +
    researchGroupInfo.databaseKey);

    DatabaseReference researchGroupReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing researchGroupReference
      researchGroupReference = researchGroupReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    researchGroupReference = researchGroupReference.child(this._RESEARCHGROUPROOTLOCATION)
        .child(researchGroupInfo.databaseKey);
    // use onValue instead of once() to read data here as we want to read data and
    // then also update data if any changes have occurred to the database
    researchGroupReference.onValue.listen((event) {
      DataSnapshot dataSnapshot = event.snapshot;
      Map<String, dynamic> researchGroupJSON = jsonDecode(dataSnapshot.value.toString()) as Map<String,dynamic>;
      ResearchGroup retrievedResearchGroup = ResearchGroup.fromJSON(researchGroupJSON);
      callback(retrievedResearchGroup);
    });
  }

  /// returns a Stream of Event objects, representing data for the ResearchGroup specified
  /// by the input researchGroupInfo, this stream is refreshed whenever any changes to the
  /// target ResearchGroup occur, ie data is reloaded whenever the ResearchGroup with
  /// database key researchGroupInfo.databaseKey is changed
  /// Preconditions: researchGroupInfo.databaseKey.isNotEmpty
  /// Postconditions: returns a Stream of Event objects described above
  Stream<Event> getResearchGroupStream(ResearchGroupInfo researchGroupInfo){
    // ensure the input researchgroup has a database key
    assert(researchGroupInfo.databaseKey.isNotEmpty);
    Config.log.i("reading research group: " + researchGroupInfo.name + " as a stream using key: " +
    researchGroupInfo.databaseKey);

    DatabaseReference researchGroupReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing researchGroupReference
      researchGroupReference = researchGroupReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    researchGroupReference = researchGroupReference.child(this._RESEARCHGROUPROOTLOCATION)
        .child(researchGroupInfo.databaseKey);
    return researchGroupReference.onValue;
  }

  /// writes the input researchGroup to the database in it's entirety
  /// Preconditions: researchGroupInfo.databaseKey.isNotEmpty
  /// Postconditions: writes the input researchGroup to the database in it's entirety, if any
  /// other data exists at the location this researchGroup would be stored, ie
  /// researchGroup.researchGroupInfo.databaseKey, this data is overwritten by this researchGroup
  void writeResearchGroup(ResearchGroup researchGroup){
    ResearchGroupInfo researchGroupInfo = researchGroup.getResearchGroupInfo();
    // ensure the research group input has a database key
    assert(researchGroupInfo.databaseKey.isNotEmpty);
    Config.log.i("writing research group: " + researchGroup.name + " to the database using key: " +
    researchGroupInfo.databaseKey);

    DatabaseReference researchGroupReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing researchGroupReference
      researchGroupReference = researchGroupReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    researchGroupReference = researchGroupReference.child(this._RESEARCHGROUPROOTLOCATION)
        .child(researchGroupInfo.databaseKey);
    // convert the ResearchGroup object to JSON before writing to the db, this also
    // converts fields and data structures within this object to JSON
    String researchGroupJSON = jsonEncode(researchGroup);
    // we cannot write raw JSON to the database, decode this JSON to get a map which
    // preserves the structure of our object when written to the database
    Map<String, dynamic> researchGroupAsMap = json.decode(researchGroupJSON) as Map<String,dynamic>;
    researchGroupReference.set(researchGroupAsMap);
  }

  /// writes the input Subject as a SubjectInfo to the database relative to the institution
  /// specified by the input institutionInfo and research group specified by the input currentResearchGroupInfo
  /// Preconditions: institutionInfo.databaseKey.isNotEmpty && currentResearchGroupInfo.databaseKey.isNotEmpty
  /// Postconditions: writes the input Subject as a SubjectInfo to the database relative to the institution
  /// specified by the input institutionInfo and research group specified by the input currentResearchGroupInfo
  /// if the locations specified by the input research group info or institution info don't
  /// yet exist on the database, these locations are created.
  void addSubjectToInstitution(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo,
      Subject currentSubject){
    // ensure our institution and research group have database keys
    assert(institutionInfo.databaseKey.isNotEmpty);
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    // create a SubjectInfo object to get the database key of the current subject
    SubjectInfo currentSubjectInfo = currentSubject.getSubjectInfo();
    // make sure the database key of our subject is not empty
    assert(currentSubjectInfo.databaseKey.isNotEmpty);
    Config.log.i("adding subject: " + currentSubject.id + " to institution: " + institutionInfo.name +
    " under research group: " + currentResearchGroupInfo.name);

    DatabaseReference institutionSubjectReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing institutionSubjectReference
      institutionSubjectReference = institutionSubjectReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    institutionSubjectReference = institutionSubjectReference.child(this._RESEARCHGROUPDATALOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(this._SUBJECTSDATALOCATION)
        .child(institutionInfo.databaseKey)
        .child(currentSubjectInfo.databaseKey);

    // convert our SubjectInfo to be added to this institution to JSON
    String subjectInfoJSON = jsonEncode(currentSubjectInfo);

    // convert the resulting JSON to a map that can be properly written to our database
    Map<String, dynamic> subjectInfoMap = json.decode(subjectInfoJSON) as Map<String,dynamic>;
    // write this map to the database

    institutionSubjectReference.set(subjectInfoMap);

    // TODO: write this subject object itself to the database additionally
  }

  /// writes the input Meal in it's entirety to the database in a location relative to the research group
  /// specified by the input ResearchGroupInfo
  /// Preconditions: currentResearchGroupInfo.databaseKey.isNotEmpty && currentMeal.getMealInfo().databaseKey.isNotEmpty
  /// Postconditions: writes the input Meal in it's entirety to the database in a location relative to the research group
  /// specified by the input ResearchGroupInfo, if the location specified by the input research group info doesn't
  /// yet exist on the database, it is created.
  void writeMealToDatabase(ResearchGroupInfo currentResearchGroupInfo, Meal currentMeal){
    // ensure the input research group and meal have database keys
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    MealInfo currentMealInfo = currentMeal.getMealInfo();
    assert(currentMealInfo.databaseKey.isNotEmpty);
    Config.log.i("writing meal: " + currentMeal.id + " to the database under research group: " +
    currentResearchGroupInfo.name);

    DatabaseReference mealReference = _databaseInstance.reference();
    if(kDebugMode){
      // app is in debug mode, have the database write to a location specific to each
      // app user, add this to our ongoing mealReference
      mealReference = mealReference.child(Authentication().getCurrentSignedInUser().uid);
    }
    mealReference = mealReference.child(this._RESEARCHGROUPDATALOCATION)
        .child(currentResearchGroupInfo.databaseKey)
        .child(this._MEALSDATALOCATION)
        .child(currentMealInfo.databaseKey);

    // convert our Meal to be added to the database to JSON
    String mealJSON = jsonEncode(currentMeal);

    // convert the resulting JSON to a map that can be written to our database
    Map<String,dynamic> mealMap = json.decode(mealJSON) as Map<String,dynamic>;

    mealReference.set(mealMap);
  }
}