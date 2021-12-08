import 'package:vivarium_control_unit/utils/firebase/googleAuth/googleAuth.dart';

/// Used for web application without Google Auth support
@deprecated
class GoogleAuthDisabled extends GoogleAuth {
  @override
  Future<Credentials?> signIn() async {
    return null;
  }

  @override
  Future<void> signOut() async {}
}
