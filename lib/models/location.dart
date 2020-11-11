import 'package:cloud_firestore/cloud_firestore.dart';

enum Condition { GREEN, YELLOW, RED }

class Location {
  final String id;
  final String name;
  final Condition condition;
  final Timestamp lastUpdate;
  final int deviceCount;


  const Location(
      {this.id, this.name, this.condition, this.lastUpdate, this.deviceCount});

  Location.fromJson(Map<String, dynamic> data, String id)
      : this(
            id: id,
            name: data['name'],
            condition: Condition.values[data['condition']],
            lastUpdate: data['lastUpdate'],
            deviceCount: data['deviceCount']);


}
