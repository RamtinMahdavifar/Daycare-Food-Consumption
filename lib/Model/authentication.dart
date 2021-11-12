import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plate_waste_recorder/Helper/config.dart';

/// This class is implemented using the singleton pattern so there can only be
/// one instance of this authentication class
class Authentication{
  static final FirebaseAuth _firebaseAuthenticationInstance = FirebaseAuth.instance;
  static final GoogleSignIn _googleAuthenticationInstance = GoogleSignIn();

  // create an instance of this class right away, this instance is our singleton
  // instance
  static final Authentication _instance = Authentication._privateConstructor();

  // declare a private constructor for this class which will allocate memory etc
  // for the class, this is only callable from within the class, ie no other
  // entities can create instances of this class
  Authentication._privateConstructor();
  
  // define a factory pattern that allows other entities to access the instance
  // of this class, this particular factory constructor should be invoked
  // like Authentication(), methods can then be called from this for example
  // Authentication().method()
  factory Authentication(){
    return _instance;
  }

  /// This method will create a popup window where the user will be prompted to login
  /// using google, at this point the user can regularly login using their gmail account
  /// Preconditions: The user is not already signed in, if the user has already signed
  /// in, calling this method will simply do nothing
  /// Postconditions: The user is logged into the app using google authentication
  /// if authentication was successful, information for the currently signed in
  /// user can then be found by calling getCurrentSignedInUser(). A FirebaseAuthException
  /// is thrown if any errors occur during the login process, if the user enters
  /// invalid credentials for example.
  Future<void> googleSignIn() async{
    try{
      // attempt to sign in via google, this will wait until the user has specified
      // their google account username and password, ie this creates a popup asking
      // the user to sign in with their google account
      GoogleSignInAccount? googleSignInAccount = await _googleAuthenticationInstance.signIn();
      // get the authentication details of the user so long as the account being signed
      // into is not null, as long as the user has entered the information for their
      // google account in the previous popup, get the resulting google authentication token
      GoogleSignInAuthentication googleAuthentication = await googleSignInAccount!.authentication;
      // generate an authentication token using the information from the google
      // authentication token to provide to firebase authentication to login using
      // google
      AuthCredential authenticationToken = GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken, idToken: googleAuthentication.idToken
      );
      // finally sign in using the produced token to firebase
      await _firebaseAuthenticationInstance.signInWithCredential(authenticationToken);
    }
    on FirebaseAuthException catch(e){
      Config.log.e("error occurred while logging in via google, error message: " + e.message.toString());
      // rethrow our exception as we can't deal with it here
      rethrow;
    }
  }

  /// Calling this method logs the user out of both google authentication and firebase
  /// authentication and makes it impossible for their information to be extracted
  /// using getCurrentSignedInUser()
  /// Preconditions: The user must be signed in in order to sign out, otherwise
  /// calling this method does nothing
  /// Postconditions: the user is signed out of the app as described above
  void googleSignOut() async{
    // sign out of both google and firebase authentication
    await _googleAuthenticationInstance.signOut();
    await _firebaseAuthenticationInstance.signOut();
  }

  /// Returns a User object denoting the currently signed in user of the app,
  /// Preconditions: User must have signed in previously, if the user hasn't signed
  /// in using google authentication, an Exception is thrown
  /// Postconditions: Returns a User object describing the currently signed in user
  /// of the app
  User getCurrentSignedInUser(){
    User? currentSignedInUser = _firebaseAuthenticationInstance.currentUser;
    if(currentSignedInUser == null){
      throw new Exception("There is no user currently signed in, to get the currently signed in user, log in");
    }
    else{
      return currentSignedInUser;
    }
  }
}