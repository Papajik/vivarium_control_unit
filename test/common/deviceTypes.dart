import 'dart:ui';

enum DeviceType {
  NOTE_9_PRO,
}

Size? getDeviceSize(DeviceType type) {
  var s;
  switch (type) {
    case DeviceType.NOTE_9_PRO:
      s = Size(393, 873);
      break;
    default:
      break;
  }
  return s;
}
