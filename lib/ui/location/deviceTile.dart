import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device/device.dart';
import 'package:vivarium_control_unit/models/device/deviceInfo.dart';
import 'package:vivarium_control_unit/ui/device/devicePage.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key key, this.device}) : super(key: key);

  final Device device;

  @override
  Widget build(BuildContext context) {
    print('deviceTile build');
    return ListTile(
        title: Text(device.info.name) ?? Text('Unknown device'),
        subtitle: Builder (
          builder: (context){
            switch (device.info.type){
              case Type.AQUARIUM:
                return Text('Aquarium');
              case Type.TERRARIUM:
                return Text('Terrarium');
              default:
                return Text('');
            }
          },
        ),
        trailing: Column(
          children: <Widget>[
            Text('Last update'),
            Text(device.sensorData.updateTime.toIso8601String())
          ],
        ),
        leading: Builder(
          builder: (context) {
            switch (device.info.condition) {
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
              .push(MaterialPageRoute<void>(builder: (BuildContext context) {
            return DevicePage(device: device);
          }));
        });
  }
}
