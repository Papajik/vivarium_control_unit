import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'waterHeaterType.g.dart';

@HiveType(typeId: 4)
enum HeaterType {
  @HiveField(0)
  PID,
  @HiveField(1)
  AUTO
}

extension HeaterTypeExtension on HeaterType {
  String get text => describeEnum(this);
}

HeaterType getHeaterTypeByName(name) =>
    HeaterType.values.firstWhere((element) => element.text == name);

String getHeaterTypeString(index) => HeaterType.values[index].text;

int getIndexOfHeaterTypeFromString(name) =>
    HeaterType.values.firstWhere((element) => element.text == name).index;
