import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/location.dart';
import 'package:vivarium_control_unit/ui/location/locationPage.dart';
import 'package:vivarium_control_unit/utils/auth.dart';

class LocationTile extends StatelessWidget {
  const LocationTile({Key key, this.location})
      : super(key: key);



  final Location location;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(location.name ?? "Unknown location"),
      subtitle: Text(location.deviceCount.toString() + " devices"),
      trailing: Column(
        children: <Widget>[
          Text("Last update"),
          Text(location.lastUpdate.toDate().toIso8601String()),
          Text(location.id)
        ],
      ),
      leading: Builder(
        builder: (context) {
          switch (location.condition) {
            case Condition.GREEN:
              return Icon(Icons.check_circle_outline, color: Colors.green);
              break;
            case Condition.YELLOW:
              return Icon(Icons.error_outline, color: Colors.orange);
              break;
            case Condition.RED:
              return Icon(Icons.error_outline, color: Colors.red);
              break;
          }
          return null;
        },
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (BuildContext context) {
          return new LocationPage(location: location, uid: userId);
        }));
      },
      onLongPress: () {},
    );
  }
}
