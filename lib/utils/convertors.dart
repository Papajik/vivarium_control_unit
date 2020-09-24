import 'dart:typed_data';

import 'dart:ui';


int getHourFromTime(int time){
  final list = new Uint64List.fromList([time]);
  final bytes = new Uint8List.view(list.buffer);
  return bytes.elementAt(0);
}

int getMinuteFromTime(int time){
  final list = new Uint64List.fromList([time]);
  final bytes = new Uint8List.view(list.buffer);
  return bytes.elementAt(1);
}

int getTime(int hour, int minute){
  final hourList = new Uint64List.fromList([hour]);
  final hourBytes = new Uint8List.view(hourList.buffer);
  final minuteList = new Uint64List.fromList([minute]);
  final minuteBytes = new Uint8List.view(minuteList.buffer);
  final Uint8List l =  Uint8List.fromList([0x00, 0x00, minuteBytes.first, hourBytes.first]);
  return ByteData.sublistView(l).getInt32(0);
}

int getIntFromColor(Color color){
  print(color);
  print(color.value);
  print(color.red);
  print(color.green);

  return 1; //TODO upravit
}