import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;
String userId;
String photonSecret;
String photonAccessToken;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult = await _auth.signInWithCredential(credential);

  final User user = authResult.user;


  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoURL != null);
  assert(user.uid != null);

  userId = user.uid;
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoURL;
  IdTokenResult idToken = await user.getIdTokenResult();

  print("UserID = "+userId);
  print("idToken = "+idToken.toString());


  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final User currentUser = _auth.currentUser;
  assert(user.uid == currentUser.uid);

  photonSecret = await createOrGetPhotonSecret(userId);
  photonAccessToken = await getPhotonAccessToken(userId);
  print(photonSecret);

  return 'signInWithGoogle succeeded: $user';
}

Future<String> createOrGetPhotonSecret(String uid) async {
  final ref = FirebaseFirestore.instance.collection("users").doc(uid);
  String s = await ref.get().then((document) {
    if (!document.data().containsKey("particleSecret")) {
      String secret = randomAlpha(25);
      ref.set({
        "particleSecret": secret
      });
      return secret;
    } else {
      return document.data()["particleSecret"];
    }
  });
  return s;
}

Future<String> getPhotonAccessToken(String uid) async {
  final ref = FirebaseFirestore.instance.collection("users").doc(uid);
  String s = await ref.get().then((document) {
    if (!document.data().containsKey("particle_access_token")) {
      return "";
    } else {
      return document.data()["particle_access_token"];
    }
  });
  return s;
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
