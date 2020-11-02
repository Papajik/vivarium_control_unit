import 'package:hive/hive.dart';

part 'outletTrigger.g.dart';

@HiveType(typeId: 5)
class OutletTrigger extends HiveObject {
  @HiveField(0)
  int time;
  @HiveField(1)
  bool outletOn;

  OutletTrigger({
    this.time = 0,
    this.outletOn = false
  });

  factory OutletTrigger.fromJson(Map<String, dynamic> json) => new OutletTrigger(time: json['time'], outletOn: json['outletOn']);


  Map<String, dynamic> toJson() => {"time": time, 'outletOn': outletOn};

  String toString() {
    return '{"time": $time,"isOn": $outletOn }';
  }

}

