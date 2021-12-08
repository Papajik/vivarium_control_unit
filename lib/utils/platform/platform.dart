import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformInfo {
  static bool isDesktopOS() {
    if (kIsWeb) {
      return false;
    }
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
  }

  static bool isAppOS() {
    if (kIsWeb) {
      return false;
    }
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool isIOS() {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static PlatformType getCurrentPlatformType() {
    if (kIsWeb) {
      return PlatformType.Web;
    }
    if (Platform.isMacOS) {
      return PlatformType.MacOS;
    }
    if (Platform.isFuchsia) {
      return PlatformType.Fuchsia;
    }
    if (Platform.isLinux) {
      return PlatformType.Linux;
    }
    if (Platform.isWindows) {
      return PlatformType.Windows;
    }
    if (Platform.isIOS) {
      return PlatformType.iOS;
    }
    if (Platform.isAndroid) {
      return PlatformType.Android;
    }
    return PlatformType.Unknown;
  }
}

enum PlatformType { Web, iOS, Android, MacOS, Fuchsia, Linux, Windows, Unknown }
