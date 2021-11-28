import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:googleapis/drive/v3.dart' as drive; // import this package with the name drive to avoid type clobbering
import 'package:googleapis/sheets/v4.dart' as sheets; // import this package with the name sheets to avoid type clobbering
import 'package:plate_waste_recorder/Model/authentication.dart';
import 'package:plate_waste_recorder/Model/database.dart';
import 'package:plate_waste_recorder/Model/institution_info.dart';
import 'package:plate_waste_recorder/Model/research_group_info.dart';

/// Class used to access google drive to write or read files, this class is defined
/// using the singleton pattern
class DriveAccess{
  // define the http client we'll use to access google drive
  static final DriveAuthenticationClient _googleDriveClient = DriveAuthenticationClient();

  // define our DriveApi for actually accessing google drive
  static final drive.DriveApi _driveAccessApi = drive.DriveApi(_googleDriveClient);

  // define our sheets api for accessing google sheets
  static final sheets.SheetsApi _sheetsAccessApi = sheets.SheetsApi(_googleDriveClient);

  // define our one instance of this class
  static final DriveAccess _instance = DriveAccess._privateConstructor();

  // define a private constructor so this class cannot be instantiated outside of itself
  DriveAccess._privateConstructor();

  // define a factory pattern for outside entities to use, this can be called to
  // access the singleton instance of this class using DriveAccess()
  factory DriveAccess(){
    return _instance;
  }

  Future<void> uploadFile() async{
    // example
    final Stream<List<int>> mediaStream =
    Future.value([104, 105]).asStream().asBroadcastStream();
    var media = new drive.Media(mediaStream, 2);
    var driveFile = new drive.File();
    driveFile.name = "hello_world.txt";
    final result = await _driveAccessApi.files.create(driveFile, uploadMedia: media);
    print("Upload result: $result");
  }

  void exportDataToDrive(ResearchGroupInfo currentResearchGroupInfo, InstitutionInfo currentInstitutionInfo) async {
    // ensure our input institutionInfo has a valid database key, address and name
    assert(currentInstitutionInfo.name.isNotEmpty);
    assert(currentInstitutionInfo.institutionAddress.isNotEmpty);
    assert(currentInstitutionInfo.databaseKey.isNotEmpty);
    // ensure our input researchGroupInfo has a valid database key
    assert(currentResearchGroupInfo.databaseKey.isNotEmpty);
    // create our spreadsheet to store exported data initially, we export data for the particular
    // specified input institution, the name of the resulting file should reflect this
    drive.File institutionDataSpreadsheet = drive.File();
    institutionDataSpreadsheet.name = "${currentInstitutionInfo.name}_${currentInstitutionInfo.institutionAddress}_data";
    // set the file type/mime type of our created file to a google spreadsheet
    institutionDataSpreadsheet.mimeType = 'application/vnd.google-apps.spreadsheet';
    // create our spreadsheet file on drive
    drive.File exportedDriveSpreadsheet = await _driveAccessApi.files.create(institutionDataSpreadsheet);

    // now we must read data for all subjects of the specified institution and write this data
    // to this newly created spreadsheet
    DataSnapshot snapshotData = await Database().readAllInstitutionSubjectData(currentResearchGroupInfo, currentInstitutionInfo);
    Config.log.i("subject data ${snapshotData.value}");
    if(snapshotData.value != null){
      // our read in data is not null, ie we have some data for export within this institution
      Map<dynamic, dynamic> snapshotDataMap = snapshotData.value as Map<dynamic, dynamic>;
      // convert our data to JSON then back to a map to ensure it is in a standardized
      // usable format with string keys etc
      String subjectDataJSON = jsonEncode(snapshotDataMap);
      Map<String, dynamic> subjectDataMap = json.decode(subjectDataJSON);
      // the keys of this resulting subjectDataMap are subject IDs, the values of this map
      // are maps containing subject meal data
      // we can write a line to this spreadsheet using a list of values, create a list
      // of lists that represent the lines to be written to this spreadsheet
      List<List<String>> spreadsheetExportData = [];
      subjectDataMap.values.forEach((value){
        // first add the subject ID to it's own line of the spreadsheet
        Map<String, dynamic> currentSubjectData = value as Map<String, dynamic>;
        spreadsheetExportData.add(["Data For Subject ${currentSubjectData["_subjectId"].toString()}:"]);

        // next add data for all meals the subject has
        Map<String, dynamic> mealDataMap = currentSubjectData["_mealData"] as Map<String, dynamic>;
        if(mealDataMap == null){
          // our mealDataMap does not exist, we do not have meal data for the current subject
          // indicate that the current subject has no meal data in our exported spreadsheet
          spreadsheetExportData.add(["No data present for subject"]);
        }
        else{
          // our mealDataMap does exist, we have meal data for the current subject
          // this new map of meals contains as keys the ID of each meal, and as values
          // a map containing any of 3 keys, uneaten, eaten or container each having a value of
          // the meal data submitted for that foodStatus
          mealDataMap.values.forEach((value){
            Map<String, dynamic> mealStatusMap = value as Map<String, dynamic>;
            if(mealStatusMap["uneaten"] != null){
              // the current meal has an uneaten entry submitted, create a line in our spreadsheet for this data
              Map<String, dynamic> mealDataForStatus = mealStatusMap["uneaten"] as Map<String, dynamic>;
              List<String> currentMealData = [];
              currentMealData.add(mealDataForStatus["_mealDate"]);
              currentMealData.add(mealDataForStatus["_mealName"]);
              currentMealData.add("uneaten");
              currentMealData.add(mealDataForStatus["_mealWeight"].toString());
              if(mealDataForStatus["_comments"]!=null && mealDataForStatus["_comments"]!=""){
                // if we have comments, add these to our new line representing this meal
                currentMealData.add(mealDataForStatus["_comments"]);
              }
              // add our currentMealData list to our list of spread lines
              spreadsheetExportData.add(currentMealData);
            }
            if(mealStatusMap["eaten"] != null){
              // the current meal has an uneaten entry submitted, create a line in our spreadsheet for this data
              Map<String, dynamic> mealDataForStatus = mealStatusMap["eaten"] as Map<String, dynamic>;
              List<String> currentMealData = [];
              currentMealData.add(mealDataForStatus["_mealDate"]);
              currentMealData.add(mealDataForStatus["_mealName"]);
              currentMealData.add("eaten");
              currentMealData.add(mealDataForStatus["_mealWeight"].toString());
              if(mealDataForStatus["_comments"]!=null && mealDataForStatus["_comments"]!=""){
                // if we have comments, add these to our new line representing this meal
                currentMealData.add(mealDataForStatus["_comments"]);
              }
              // add our currentMealData list to our list of spread lines
              spreadsheetExportData.add(currentMealData);
            }
            if(mealStatusMap["container"] != null){
              // the current meal has an uneaten entry submitted, create a line in our spreadsheet for this data
              Map<String, dynamic> mealDataForStatus = mealStatusMap["container"] as Map<String, dynamic>;
              List<String> currentMealData = [];
              currentMealData.add(mealDataForStatus["_mealDate"]);
              currentMealData.add(mealDataForStatus["_mealName"]);
              currentMealData.add("container");
              currentMealData.add(mealDataForStatus["_mealWeight"].toString());
              if(mealDataForStatus["_comments"]!=null && mealDataForStatus["_comments"]!=""){
                // if we have comments, add these to our new line representing this meal
                currentMealData.add(mealDataForStatus["_comments"]);
              }
              // add our currentMealData list to our list of spread lines
              spreadsheetExportData.add(currentMealData);
            }
          });
        }
      });

      sheets.ValueRange sheetData = sheets.ValueRange.fromJson({
        "values": spreadsheetExportData
      });
      await _sheetsAccessApi.spreadsheets.values.append(sheetData, exportedDriveSpreadsheet.id!, "A:P", valueInputOption: "USER_ENTERED");
    }
    else{
      // our read in data is null, we have no data to export
      // TODO: display a message to the user indicating the specified institution has no data to export
    }
  }
}







/// Class used as an http client to handle authentication when using google drive apis, this class
/// extends the http BaseClient class as this class already has implementations for
/// standard http operations ie get, post etc
class DriveAuthenticationClient extends BaseClient{ // this class is a sort of helper class for our DriveAccess class
  // we use standard http requests to access google drive, store our http client
  Client _httpClient = new Client();

  /// sends the input initialRequest to it's target destination after adding google
  /// drive authentication headers to the request
  /// Preconditions: initialRequest is an http request to some location, current user of
  /// the app must be signed in to the app using google authentication
  /// Postconditions: the input initialRequest is sent to it's destination with google
  /// authentication headers added, headers present in the initialRequest are unchanged
  @override
  Future<StreamedResponse> send(BaseRequest initialRequest) async{
    // here we override the send method, this method will then be used in lieu of the
    // regular http client send method, this ensures that all requests made using this class
    // will be send with google authentication headers

    // get the headers containing google authentication information from the current
    // signed in user
    // TODO: is it best to get authentication headers inside this method, want to separate concerns
    Map<String,String> googleAuthenticationHeaders = await Authentication().getCurrentSignedInGoogleAccount().authHeaders;
    // add the google authentication headers to our initial request
    Config.log.i(initialRequest.headers);
    initialRequest.headers.addAll(googleAuthenticationHeaders);
    Config.log.i(initialRequest.headers);
    // send this request using the regular http client send
    return this._httpClient.send(initialRequest);
  }
}