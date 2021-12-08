import 'dart:ui';

int _offset = 0; // DateTime.now().timeZoneOffset.inHours;


int getTimeFromString(String time) {
  var t = time.split(':');
  return getTime(int.parse(t[0]), int.parse(t[1]));
}

String getTimeStringFromTime(int? time) {
  if (time == null) return '__:__';
  var lsHour = getHourFromTime(time).toString().padLeft(2, '0');
  var lsMinute = getMinuteFromTime(time).toString().padLeft(2, '0');
  return lsHour + ':' + lsMinute;
}

int getHourFromTime(int time) {
  var h = time + _offset*256;
  if (h == 24) h = 0;
  return (h / 256).floor();
}

int getMinuteFromTime(int time) {
  return time % 256;
}

int getTime(int hour, int minute) {
  var h = hour - _offset;
  if (h == -1) h = 23;
  return h * 256 + minute;
}

int getIntFromColor(Color color) {
  return ((color.red & 0xff) << 16) +
      ((color.green & 0xff) << 8) +
      ((color.blue & 0xff) << 0);
}

Color getColorFromInt(int i) {
  return Color.fromARGB(255, (0x00ff0000 & i) >> 16, (0x0000ff00 & i) >> 8,
      (0x000000ff & i) >> 0);
}
