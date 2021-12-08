import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class ModuleCard extends StatefulWidget {
  final String moduleKey;
  final String? deviceMac;
  final String? deviceId;
  final String title;
  final bool? connected;
  final Widget child;

  const ModuleCard(
      {Key? key,
      required this.moduleKey,
      required this.deviceMac,
      required this.child,
      required this.connected,
      required this.title,
      required this.deviceId})
      : super(key: key);

  @override
  _ModuleCardState createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool? _connected;

  @override
  void initState() {
    _connected = widget.connected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<DeviceProvider>(
              builder: (context, provider, child) => SwitchListTile(
                onChanged: (bool value) {
                  setState(() {
                    _connected = value;
                    provider.saveValue(
                        value: value,
                        key: widget.moduleKey);
                  });
                },
                value: _connected!,
                title: Text(
                  widget.title,
                  style: TextStyle(fontSize: 26, color: Colors.cyanAccent),
                ),
                subtitle: Text(_connected! ? 'Connected' : 'Disconnected',
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
            Visibility(
              visible: _connected!,
              child: widget.child,
            )
          ],
        ));
  }
}
