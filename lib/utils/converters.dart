import 'dart:typed_data';
import 'dart:ui';

int getTimeFromString(String time) {
  var t = time.split(':');
  return getTime(int.parse(t[0]), int.parse(t[1]));
}

String getTimeStringFromTime(int time) {
  var lsHour = getHourFromTime(time).toString().padLeft(2, '0');
  var lsMinute = getMinuteFromTime(time).toString().padLeft(2, '0');
  return lsHour + ':' + lsMinute;
}

int getHourFromTime(int time) {
  final list = Uint64List.fromList([time]);
  final bytes = Uint8List.view(list.buffer);
  return bytes.elementAt(1);
}

int getMinuteFromTime(int time) {
  final list = Uint64List.fromList([time]);
  final bytes = Uint8List.view(list.buffer);
  return bytes.elementAt(0);
}

int getTime(int hour, int minute) {
  final hourList = Uint64List.fromList([hour]);
  final hourBytes = Uint8List.view(hourList.buffer);
  final minuteList = Uint64List.fromList([minute]);
  final minuteBytes = Uint8List.view(minuteList.buffer);
  final l =
      Uint8List.fromList([0x00, 0x00, hourBytes.first, minuteBytes.first]);
  return ByteData.sublistView(l).getInt32(0);
}

int getIntFromColor(Color color) {
  print(color);
  print(color.value);
  print(color.red);
  print(color.green);

  return 1; //TODO upravit
}
