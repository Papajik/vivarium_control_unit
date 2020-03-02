import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/ui/device/devicePage.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key key, this.device}) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(device.name) ?? Text("Unknown device"),
        subtitle: Builder (
          builder: (context){
            switch (device.type){
              case Type.AQUARIUM:
                return Text("Akvarium");
              case Type.TERRARIUM:
                return Text("Terrarium");
              case Type.UNKNOWN:
              default:
                return Text("");
            }
          },
        ),
        trailing: Column(
          children: <Widget>[
            Text("Last update"),
            Text(device.sensorValues.updateTime.toDate().toIso8601String())
          ],
        ),
        leading: Builder(
          builder: (context) {
            switch (device.condition) {
              case Condition.GREEN:
                return Icon(Icons.check_circle_outline, color: Colors.green);
                break;
              case Condition.YELLOW:
                return Icon(Icons.error_outline, color: Colors.orange);
                break;
              case Condition.RED:
                return Icon(Icons.error_outline, color: Colors.red);
                break;
              case Condition.UNKNOWN:
                return Icon(Icons.error);
            }
            return null;
          },
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
            return new DevicePage(device: device);
          }));
        });
  }
}
