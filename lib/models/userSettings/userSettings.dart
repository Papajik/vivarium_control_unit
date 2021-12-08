class UserSettings {
  final bool? notifyOnConnectionUpdate;
  final bool? notifyOnCrossLimit;
  final int? notificationDelay;
  final bool? distinctNotification;
  final bool? trackDevicesAlive;

  UserSettings(
      {this.notifyOnConnectionUpdate,
      this.notifyOnCrossLimit,
      this.notificationDelay,
      this.distinctNotification,
      this.trackDevicesAlive});

  Map<String, dynamic> toJson() => {
        'nConn': notifyOnConnectionUpdate,
        'nDelay': notificationDelay,
        'nLimit': notifyOnCrossLimit,
        'nDist': distinctNotification,
        'tAlive': trackDevicesAlive
      };

  factory UserSettings.fromJson(Map map) => UserSettings(
        notifyOnConnectionUpdate: map['nConn'],
        notificationDelay: (map['nDelay'] as num).round(),
        notifyOnCrossLimit: map['nLimit'],
        distinctNotification: map['nDist'],
        trackDevicesAlive: map['tAlive'],
      );
}
