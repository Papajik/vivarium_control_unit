import 'package:google_sign_in/google_sign_in.dart';
import 'package:vivarium_control_unit/utils/firebase/googleAuth/googleAuth.dart';

class GoogleAuthImp extends GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<Credentials?> signIn() async {
    var googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) return null;
    final googleSignInAuthentication = await googleSignInAccount.authentication;
    return Credentials(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
  }

  @override
  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) await _googleSignIn.signOut();
  }
}
