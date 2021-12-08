import 'common/deviceTypes.dart';
import 'test_homePage.dart';
import 'test_login.dart';
import 'test_navigationDrawer.dart';

void main() {
  for (var d in DeviceType.values) {
    var size = getDeviceSize(d);
    testHomePage(size);
    testNavigationDrawer(size);
    testLogin(size);
  }
}
