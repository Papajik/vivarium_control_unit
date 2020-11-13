import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
]);

String name;
String email;
String imageUrl;
String userId;
String photonSecret;
String photonAccessToken;

Future<String> signInWithGoogle() async {
  print('signInWithGoogle');

  var googleSignInAccount = await _handleSignIn();

  print(0);
  final googleSignInAuthentication = await googleSignInAccount.authentication;
  print('1');

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  print('2');

  final authResult = await _auth.signInWithCredential(credential);
  print('3');
  final user = authResult.user;
  print('4');
  print(user);
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoURL != null);
  assert(user.uid != null);

  userId = user.uid;
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoURL;
  var idToken = await user.getIdTokenResult();

  print('UserID = ' + userId);
  print('idToken = ' + idToken.toString());

  if (name.contains(' ')) {
    name = name.substring(0, name.indexOf(' '));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final currentUser = _auth.currentUser;
  assert(user.uid == currentUser.uid);

  photonSecret = await createOrGetPhotonSecret(userId);
  photonAccessToken = await getPhotonAccessToken(userId);
  print(photonSecret);

  return 'signInWithGoogle succeeded: $user';
}

 Future<GoogleSignInAccount> _handleSignIn() async {
  try {
    return _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<String> createOrGetPhotonSecret(String uid) async {
  final ref = FirebaseFirestore.instance.collection('users').doc(uid);
  var secret = await ref.get().then((document) {
    if (!document.data().containsKey('particleSecret')) {
      var secret = randomAlpha(25);
      ref.set({'particleSecret': secret});
      return secret;
    } else {
      return document.data()['particleSecret'];
    }
  });
  return secret;
}

Future<String> getPhotonAccessToken(String uid) async {
  final ref = FirebaseFirestore.instance.collection('users').doc(uid);
  var s = await ref.get().then((document) {
    if (!document.data().containsKey('particle_access_token')) {
      return '';
    } else {
      return document.data()['particle_access_token'];
    }
  });
  return s;
}

void signOutGoogle() async {
  await _googleSignIn.signOut();

  print('User Sign Out');
}
