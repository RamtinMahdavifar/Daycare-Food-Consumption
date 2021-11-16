import 'package:http/http.dart';
import 'package:plate_waste_recorder/Helper/config.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:plate_waste_recorder/Model/authentication.dart';

/// Class used to access google drive to write or read files, this class is defined
/// using the singleton pattern
class DriveAccess{
  // define the http client we'll use to access google drive
  static final DriveAuthenticationClient _googleDriveClient = DriveAuthenticationClient();

  // define our DriveApi for actually accessing google drive
  static final DriveApi _driveAccessApi = DriveApi(_googleDriveClient);

  // define our one instance of this class
  static final DriveAccess _instance = DriveAccess._privateConstructor();

  // define a private constructor so this class cannot be instantiated outside of itself
  DriveAccess._privateConstructor();

  // define a factory pattern for outside entities to use, this can be called to
  // access the singleton instance of this class using DriveAccess()
  factory DriveAccess(){
    return _instance;
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