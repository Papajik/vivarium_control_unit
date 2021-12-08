import 'package:vivarium_control_unit/utils/firebase/googleAuth/googleAuthImp.dart';

class Credentials {
  final String? accessToken;
  final String? idToken;

  Credentials({this.accessToken, this.idToken});
}

GoogleAuth get googleAuth => GoogleAuthImp();

abstract class GoogleAuth {
  Future<void> signOut();

  Future<Credentials?> signIn();
}
