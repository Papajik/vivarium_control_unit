class Peripheral{
  bool enabled;
  String nameKey;
  bool hasAdditionalInfo;

  static Map<String, String> nameValues = {
    'fan':'Fan',
    'feeder':'Feeder',
    'filter':'Filter',
    'heater':'Heater',
    'led': 'Light',
    'ph': 'PH',
    'pump': 'Water pump',
    'water': 'Water level sensor',
    'temp1': 'Temperature 1',
    'temp2': 'Temperature 2'
  };

  Peripheral({this.enabled, this.hasAdditionalInfo, this.nameKey});

  Peripheral.fromJson(Map<String, dynamic> data)
      : this(
    hasAdditionalInfo: data['additionalInfo'],
    nameKey: data['nameKey'],
    enabled: data['enabled']

  );


  Map<String, dynamic> toJson() => {
    nameValues[nameKey]: enabled,
    'additionalInfo': hasAdditionalInfo
  };
}

