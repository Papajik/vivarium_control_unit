import 'package:hive/hive.dart';

part 'waterHeaterType.g.dart';

@HiveType(typeId: 4)
enum HeaterType {
  @HiveField(0)
  PID,
  @HiveField(1)
  AUTO
}
