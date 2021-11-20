// import 'package:flutter/material.dart';
import 'dart:io';

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
/// If methods from this class are invoked from an app in debug mode, ie kDebugMode is true,
/// database reads and writes occur in a sort of sandbox for the current user of the app
/// ie data is stored relative to Authentication().getCurrentSignedInUser().uid, the
/// user ID of the current signed in user of the app, otherwise, if the app is not
/// being ran in debug mode database reads and writes use a shared location accessible
/// by all users of the app
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

  // initialize the location we store subjects for a particular institution at
  final String _INSTITUTIONSSUBJECTSLOCATION = "_subjectsMap";

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

  /// Asynchronously checks if there is data at the location specified by the input String database path
  /// Preconditions: databasePath.isNotEmpty, this databasePath should be the path
  /// to some location on the database relative to the root of the database, for example
  /// providing a path "/example/test" checks if there is a data item with the key
  /// test for the child example of the root of the database.
  /// Postconditions: Returns a Future<bool> containing true if the input databasePath
  /// exists and data is stored at this location on the database, and false otherwise.
  Future<bool> _dataExistsAtPath(String databasePath) async{
    assert(databasePath.isNotEmpty);
    // there is no other way to check if data exists on our database at some location
    // than to attempt read the data at that location and check if we receive any results
    DatabaseReference desiredLocationReference = _databaseInstance.reference().child(databasePath);

    // read the data at desiredLocationReference and determine if any values are retrieved
    // calling .then will return a Future by default, store whether
    // our desired data exists within this future
    return await desiredLocationReference.once().then((DataSnapshot dataSnapshot)=>(dataSnapshot.exists));
  }

  /// writes the input institution as an InstitutionInfo under the research group specified by the
  /// input ResearchGroupInfo, the input institution is also written in it's entirety to the database in
  /// it's own distinct location, this location is still relative to the input research group
  /// Preconditions: currentResearchGroupInfo.databaseKey.isNotEmpty, institution.getInstitutionInfo().databaseKey.isNotEmpty,
  /// An institution with the database key institution.getInstitutionInfo().databaseKey,
  /// must not already exist for the research group specified by the database key
  /// currentResearchGroupInfo.databaseKey, if such an institution already exists
  /// an exception is thrown
  /// Postconditions: writes the input institution as an InstitutionInfo under the research group specified by the
  /// input ResearchGroupInfo, the input institution is also written in it's entirety to the database in
  /// it's own distinct location, this location is still relative to the input research group
  /// if the location specified by the input research group info doesn't
  /// yet exist on the database, it is created.
  Future<void> addInstitutionToResearchGroup(Institution institution, ResearchGroupInfo currentResearchGroupInfo) async{
    // ensure the input researchgroup has a database key
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    InstitutionInfo currentInstitutionInfo = institution.getInstitutionInfo();
    // ensure the input institution has a database key
    assert(currentInstitutionInfo.databaseKey.isNotEmpty);
    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPROOTLOCATION/${currentResearchGroupInfo.databaseKey}/$_RESEARCHGROUPINSTITUTIONSLOCATION/${currentInstitutionInfo.databaseKey}";
    // check if the input institution already exists for the input research group
    await _dataExistsAtPath(dataPath).then((dataExists){
      if(dataExists){
        Config.log.e("Institution with address: ${institution.address} already exists for the research group: ${currentResearchGroupInfo.databaseKey}");
        throw Exception("Institution with address: ${institution.address} already exists on the database");
      }
      else{
        // the institution we're trying to write to the database doesn't already exist there
        // write this institution
        DatabaseReference institutionReference = _databaseInstance.reference().child(dataPath);

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
    });
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


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroupInfo.databaseKey}/$_INSTITUTIONSDATALOCATION/${currentInstitutionInfo.databaseKey}";
    DatabaseReference institutionReference = _databaseInstance.reference().child(dataPath);

    Config.log.i("Writing institution: " + institution.name + " to the database");

    // convert our Institution Object to json to be written to location institutionReference
    String institutionJSON = jsonEncode(institution);

    // convert the produced JSON to a map which can be stored on our database, storing
    // JSON directly will simply store the JSON as a single string instead of storing
    // each field of our object with it's value as we want
    Map<String, dynamic> institutionMap = json.decode(institutionJSON) as Map<String,dynamic>;
    // write this to the location specified above
    institutionReference.set(institutionMap);

    // additionally write the map of subjects present in this institution to a distinct location
    _initializeInstitutionSubjects(institution, currentResearchGroupInfo);
  }

  /// Writes all initial subjects for an Institution onto the database using a single write
  /// ie this writes every subject whose corresponding SubjectInfo object is present
  /// in institution.subjectsMap to the database as a Subject object in a distinct location
  /// relative to the input institution and research group
  /// Preconditions: currentResearchGroupInfo.databaseKey.isNotEmpty && currentInstitutionInfo.databaseKey.isNotEmpty
  /// Postconditions: all subjects present for the input institution are written to the database
  /// in a single operation as described above
  void _initializeInstitutionSubjects(Institution institution, ResearchGroupInfo currentResearchGroupInfo){
    // make sure research group input has a database key
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    // get the database key of this particular input institution from an institution info
    InstitutionInfo currentInstitutionInfo = institution.getInstitutionInfo();
    // ensure the institution provided has a database key
    assert(currentInstitutionInfo.databaseKey.isNotEmpty);


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
    // app is in debug mode, check a database location specific to the current app
    // user instead of the normal database location
    String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
    dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroupInfo.databaseKey}/$_SUBJECTSDATALOCATION/${currentInstitutionInfo.databaseKey}";
    DatabaseReference institutionSubjectsReference = _databaseInstance.reference().child(dataPath);

    // convert the map of SubjectInfo objects from our institution to a map containing
    // subject objects as values, here the keys of this initial dictionary are subject IDs
    // and the values are SubjectInfo objects, use this to create a map containing subject ID keys
    // and Subject values, write this to the database at the location above distinct location
    Map<String, Subject> subjectsMap = institution.subjectsMap.map((key, value) => MapEntry(key, Subject(value.subjectId)));

    // convert this subjectsMap to JSON as we cannot write objects directly to our database
    String subjectsJSON = jsonEncode(subjectsMap);

    // convert our JSON back into a map we can write to the database as writing JSON
    // to the database writes all data as a single string
    Map<String, dynamic> desiredSubjectsMap = json.decode(subjectsJSON);

    institutionSubjectsReference.set(desiredSubjectsMap);
    }


  /// reads in a stream of Event objects representing data for the institution specified
  /// ie the institution object represented by the input InstitutionInfo and located under
  /// the input research group, each of these Event objects contains a datasnapshot
  /// with data related to the desired Institution, new events are automatically read
  /// whenever data related to the desired institution updated on the database
  /// Preconditions: institutionInfo.databaseKey.isNotEmpty && currentResearchGroupInfo.databaseKey.isNotEmpty
  /// Postconditions: a Stream<Event> is returned as described above
  Stream<Event> getInstitutionStream(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo){
    // ensure the input info objects contain valid database keys
    assert(institutionInfo.databaseKey.isNotEmpty);
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    Config.log.i("reading institution: " + institutionInfo.name + " from the database using database key " +
    institutionInfo.databaseKey + " for research group: " + currentResearchGroupInfo.name);


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroupInfo.databaseKey}/$_INSTITUTIONSDATALOCATION/${institutionInfo.databaseKey}";
    DatabaseReference institutionReference = _databaseInstance.reference().child(dataPath);
    return institutionReference.onValue;
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


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPROOTLOCATION/${researchGroupInfo.databaseKey}";
    DatabaseReference researchGroupReference = _databaseInstance.reference().child(dataPath);

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


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPROOTLOCATION/${researchGroupInfo.databaseKey}";
    DatabaseReference researchGroupReference = _databaseInstance.reference().child(dataPath);
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


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPROOTLOCATION/${researchGroupInfo.databaseKey}";
    DatabaseReference researchGroupReference = _databaseInstance.reference().child(dataPath);
    // convert the ResearchGroup object to JSON before writing to the db, this also
    // converts fields and data structures within this object to JSON
    String researchGroupJSON = jsonEncode(researchGroup);
    // we cannot write raw JSON to the database, decode this JSON to get a map which
    // preserves the structure of our object when written to the database
    Map<String, dynamic> researchGroupAsMap = json.decode(researchGroupJSON) as Map<String,dynamic>;
    researchGroupReference.set(researchGroupAsMap);
  }


  /// Writes the input Subject object in it's entirety to the database at a distinct location
  /// relative to institution and research group represented by the input institutionInfo and ResearchGroupInfo objects
  /// Preconditions: institutionInfo.databaseKey.isNotEmpty && currentResearchGroupInfo.databaseKey.isNotEmpty &&
  /// currentSubject.getSubjectInfo().databaseKey.isNotEmpty
  /// Postconditions: the input Subject object is written to the database as described above
  void _writeSubjectToDatabase(InstitutionInfo institutionInfo, ResearchGroupInfo currentResearchGroupInfo,
      Subject currentSubject){
    // ensure our institution and research group have database keys
    assert(institutionInfo.databaseKey.isNotEmpty);
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    // create a SubjectInfo object to get the database key of the current subject
    SubjectInfo currentSubjectInfo = currentSubject.getSubjectInfo();
    // make sure the database key of our subject is not empty
    assert(currentSubjectInfo.databaseKey.isNotEmpty);
    Config.log.i("adding subject: " + currentSubject.id + " to the database relative to institution: " + institutionInfo.name +
    " under research group: " + currentResearchGroupInfo.name);


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroupInfo.databaseKey}/$_SUBJECTSDATALOCATION/${institutionInfo.databaseKey}/${currentSubjectInfo.databaseKey}";
    DatabaseReference subjectReference = _databaseInstance.reference().child(dataPath);

    // convert our Subject to be added to the database to JSON
    String subjectJSON = jsonEncode(currentSubject);

    // convert the resulting JSON to a map that can be properly written to our database
    Map<String, dynamic> subjectMap = json.decode(subjectJSON) as Map<String,dynamic>;
    // write this map to the database

    subjectReference.set(subjectMap);
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


      // path to the desired data on the database
      String dataPath = "";
      if(kDebugMode){
        // app is in debug mode, check a database location specific to the current app
        // user instead of the normal database location
        String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
        dataPath = "$currentUserID";
      }
      dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroupInfo.databaseKey}/$_INSTITUTIONSDATALOCATION/${institutionInfo.databaseKey}/${currentSubjectInfo.databaseKey}";
      DatabaseReference institutionSubjectReference = _databaseInstance.reference().child(dataPath);

      // we only want to store our SubjectInfo object under the particular institution
      // convert this object to json to be written to location institutionSubjectReference
      String subjectInfoJSON = jsonEncode(currentSubjectInfo);

      // convert the produced JSON to a map which can be stored on our database, storing
      // JSON directly will simply store the JSON as a single string instead of storing
      // each field of our object with it's value as we want
      Map<String, dynamic> subjectInfoMap = json.decode(subjectInfoJSON) as Map<String,dynamic>;
      // write this to the location specified above
      institutionSubjectReference.set(subjectInfoMap);

      // additionally write the subject itself in it's entirety to the database in a distinct location
      _writeSubjectToDatabase(institutionInfo, currentResearchGroupInfo, currentSubject);
    }


  void addMealToSubject(ResearchGroupInfo currentResearchGroup, InstitutionInfo subjectInstitution,
        SubjectInfo currentSubject, Meal targetMeal){
    // ensure we have valid database keys for our researchGroup, institution, subject and meal
    assert(currentResearchGroup.databaseKey.isNotEmpty);
    assert(subjectInstitution.databaseKey.isNotEmpty);
    assert(currentSubject.databaseKey.isNotEmpty);
    MealInfo currentMealInfo = targetMeal.getMealInfo();
    assert(currentMealInfo.databaseKey.isNotEmpty);

    Config.log.i("writing meal ${currentMealInfo.databaseKey} to the database for subject ${currentSubject.databaseKey} under institution ${subjectInstitution.databaseKey}");
    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroup.databaseKey}/$_SUBJECTSDATALOCATION/${subjectInstitution.databaseKey}/$_INSTITUTIONSSUBJECTSLOCATION/${currentSubject.databaseKey}/";
    DatabaseReference institutionSubjectReference = _databaseInstance.reference().child(dataPath);


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


    // path to the desired data on the database
    String dataPath = "";
    if(kDebugMode){
      // app is in debug mode, check a database location specific to the current app
      // user instead of the normal database location
      String currentUserID = Authentication().getCurrentSignedInFirebaseUser().uid;
      dataPath = "$currentUserID";
    }
    dataPath = "$dataPath/$_RESEARCHGROUPDATALOCATION/${currentResearchGroupInfo.databaseKey}/$_MEALSDATALOCATION/${currentMealInfo.databaseKey}";
    DatabaseReference mealReference = _databaseInstance.reference().child(dataPath);

    // convert our Meal to be added to the database to JSON
    String mealJSON = jsonEncode(currentMeal);

    // convert the resulting JSON to a map that can be written to our database
    Map<String,dynamic> mealMap = json.decode(mealJSON) as Map<String,dynamic>;

    mealReference.set(mealMap);
  }

  /// Generates a unique String ID, this idea is generated entirely client side,
  /// ie communication to our database to generate this ID isn't required at all
  /// Preconditions: None
  /// Postconditions: returns a String ID described above
  String generateUniqueID(){
    return _databaseInstance.reference().push().key;
  }
}