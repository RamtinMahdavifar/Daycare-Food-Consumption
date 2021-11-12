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

  void googleSignIn() async{
    try{
      // attempt to sign in via google, this will wait until the user has specified
      // their google account username and password
      GoogleSignInAccount? googleSignInAccount = await _googleAuthenticationInstance.signIn();
      // get the authentication details of the user so long as the account being signed
      // into is not null
      GoogleSignInAuthentication googleAuthentication = await googleSignInAccount!.authentication;
      // generate an authentication token to provide to firebase authentication
      AuthCredential authenticationToken = GoogleAuthProvider.credential(
          accessToken: googleAuthentication.accessToken, idToken: googleAuthentication.idToken
      );
      await _firebaseAuthenticationInstance.signInWithCredential(authenticationToken);
    }
    on FirebaseAuthException catch(e){
      Config.log.e("error occurred while logging in via google, error message: " + e.message.toString());
    }
  }

  void googleSignOut() async{
    // sign out of both google and firebase authentication
    await _googleAuthenticationInstance.signOut();
    await _firebaseAuthenticationInstance.signOut();
  }

}