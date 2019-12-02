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

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);
  assert(user.uid != null);

  userId = user.uid;
  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  print(imageUrl);

  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  photonSecret = await createOrGetPhotonSecret(userId);

  return 'signInWithGoogle succeeded: $user';
}

Future<String> createOrGetPhotonSecret(String uid) async {
  final ref = Firestore.instance.collection("users").document(uid);
  String secret = "";
  ref.get().then((document) {
    if (!document.data.containsKey("particleSecret")) {
      secret = randomAlpha(15);
      ref.setData({
        "particleSecret": randomAlpha(15)
      });
    }
  });

}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
