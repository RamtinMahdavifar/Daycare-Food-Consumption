import 'package:http/http.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:googleapis/drive/v3.dart' as drive; // import this package with the name drive to avoid type clobbering
import 'package:googleapis/sheets/v4.dart' as sheets; // import this package with the name sheets to avoid type clobbering
import 'package:plate_waste_recorder/Model/authentication.dart';
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
    final result = await _driveAccessApi.files.create(institutionDataSpreadsheet);
    sheets.ValueRange sheetData = sheets.ValueRange.fromJson({
      "values": [
        ["2021/04/05", "via API", "5", "3", "3", "3", "3", "3", "3", "3"]
      ]
    });
    await _sheetsAccessApi.spreadsheets.values.append(sheetData, result.id!, "A:J");
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