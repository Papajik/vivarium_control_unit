class LedTrigger {
  int hour;
  int color;
  int second;
  int minute;

  LedTrigger({
    this.hour,
    this.color,
    this.second,
    this.minute,
  });

  factory LedTrigger.fromJson(Map<String, dynamic> json) => LedTrigger(
    hour: json["hour"],
    color: json["color"],
    second: json["second"],
    minute: json["minute"],
  );

  Map<String, dynamic> toJson() => {
    "hour": hour,
    "color": color,
    "second": second,
    "minute": minute,
  };

  Map<String, dynamic> toMap(){
    return toJson();
  }

  String toString(){
    return "Trigger:"+hour.toString()+":"+minute.toString()+":" +second.toString()+" -> ""Color: "+color.toString();
  }
}