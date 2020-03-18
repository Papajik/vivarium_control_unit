class Peripherals {
  bool fan;
  bool feeder;
  bool filter;
  bool heater;
  bool led;
  bool ph;
  bool pump;
  bool temp1;
  bool temp2;
  bool water;

  Peripherals(
      {this.fan,
      this.temp1,
      this.temp2,
      this.feeder,
      this.filter,
      this.heater,
      this.led,
      this.ph,
      this.pump,
      this.water});

  Peripherals.fromJson(Map<String, dynamic> data)
      : this(
          fan: data['fan'],
          feeder: data['feeder'],
          filter: data['filter'],
          heater: data['heater'],
          led: data['led'],
          ph: data['ph'],
          pump: data['pump'],
          temp1: data['temp1'],
          temp2: data['temp2'],
          water: data['water'],
        );

  Map<String, dynamic> toJson() => {
        "fans": fan,
        "feeder": feeder,
        "filter": filter,
        "heater": heater,
        "led": led,
        "ph": ph,
        "pump": pump,
        "temp1": temp1,
        "temp2": temp2,
        "water": water
      };
}
