import 'package:vivarium_control_unit/models/device/modules/keys.dart';

class Camera {
  final bool active;
  final DateTime updated;

  const Camera({required this.active, required this.updated});

  factory Camera.fromJson(Map data) {
    return Camera(
        active: data[cameraActiveKey].toString() == 'true' ? true : false,
        updated: data[cameraUpdatedKey] != null
            ? DateTime.fromMillisecondsSinceEpoch((data[cameraUpdatedKey] as num).toInt())
            : DateTime.fromMillisecondsSinceEpoch(0));
  }

  @override
  String toString() => '{ active: $active, updated: $updated }';

  Map<String, dynamic> toJson() =>
      {'active': active, 'updated': updated.millisecondsSinceEpoch};
}
