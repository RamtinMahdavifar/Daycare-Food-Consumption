// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:plate_waste_recorder/Model/authentication.dart';
// import 'package:mockito/mockito.dart';
// import 'package:test/test.dart';
//
// class AuthMock extends Mock implements Auth {}
//
// class FirebaseAuthMock extends Mock implements FirebaseAuth {}
//
// class FirebaseUserCredentialMock extends Mock implements UserCredential{}
//
// class FirebaseUserMock extends Mock implements User{
//   @override
//   final String displayName = 'Bruce';
// }
//
// class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount {}
//
// class GoogleSignInAuthenticationMock extends Mock implements GoogleSignInAuthentication {
//   @override
//   final String idToken = 'id';
//   @override
//   final String accessToken = 'secret';
// }
//
// class GoogleSignInMock extends Mock implements GoogleSignIn {}
//
// void main() {
//   group('Auth', () {
//     final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
//     final GoogleSignInMock googleSignInMock = GoogleSignInMock();
//     final FirebaseUserCredentialMock firebaseUserCredentialMock = FirebaseUserCredentialMock();
//     final GoogleSignInAccountMock googleSignInAccountMock = GoogleSignInAccountMock();
//     final GoogleSignInAuthenticationMock googleSignInAuthenticationMock = GoogleSignInAuthenticationMock();
//     final Auth auth = Auth(
//       auth: firebaseAuthMock,
//       googleSignIn: googleSignInMock,
//     );
//
//     test('signInWithGoogle returns a user', () async {
//       when(googleSignInMock.signIn()).thenAnswer((_) =>
//       Future<GoogleSignInAccountMock>.value(googleSignInAccountMock));
//
//       when(googleSignInAccountMock.authentication).thenAnswer((_) =>
//       Future<GoogleSignInAuthenticationMock>.value(
//           googleSignInAuthenticationMock));
//
//       when(firebaseAuthMock.signInWithCredential(
//         GoogleAuthProvider.credential(
//             accessToken: googleSignInAuthenticationMock.idToken, idToken: googleSignInAuthenticationMock.accessToken
//         )
//       )).thenAnswer((_) => Future<FirebaseUserCredentialMock>.value(firebaseUserCredentialMock));
//
//       await auth.signInWithGoogle();
//
//       verify(googleSignInMock.signIn()).called(1);
//       verify(googleSignInAccountMock.authentication).called(1);
//       verify(firebaseAuthMock.signInWithCredential(
//           GoogleAuthProvider.credential(
//               accessToken: googleSignInAuthenticationMock.idToken, idToken: googleSignInAuthenticationMock.accessToken
//           )
//       )).called(1);
//     });
//   });
// }