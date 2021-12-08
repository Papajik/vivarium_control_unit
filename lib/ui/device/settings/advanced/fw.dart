import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';
import 'package:vivarium_control_unit/utils/fwProvider/fwProvider.dart';

class FirmwareSelector extends StatefulWidget {
  final DeviceProvider? provider;

  const FirmwareSelector({Key? key, this.provider}) : super(key: key);

  @override
  _FirmwareSelectorState createState() => _FirmwareSelectorState();
}

class _FirmwareSelectorState extends State<FirmwareSelector> {
  final String _defaultValue = 'Select version';
  String? _selectedValue;

  @override
  void initState() {
    _selectedValue = _defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<String>>.value(
        initialData: [],
        value: FirmwareProvider().firmwareStream,
        catchError: (context, error) => [],
        child: Consumer<List<String>>(
            builder: (context, value, child) => (value.isEmpty)
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Firmware',
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                DropdownButton<String>(
                                  value: _selectedValue,
                                  style: Theme.of(context).textTheme.headline6,
                                  dropdownColor: Colors.black12,
                                  items: value
                                      .map((e) => DropdownMenuItem<String>(
                                          value: e, child: Text(e)))
                                      .toList()
                                    ..add(DropdownMenuItem<String>(
                                      value: _defaultValue,
                                      child: Text(_defaultValue),
                                    )),
                                  onChanged: (value) =>
                                      setState(() => _selectedValue = value),
                                )
                              ],
                            ),
                            Divider(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: updateFirmware,
                              child: Text('Update firmware'),
                            )
                          ],
                        ),
                      ),
                    ),
                  )));
  }

  void updateFirmware() {
    if (_selectedValue != _defaultValue) {
      widget.provider!.saveValue(key: 'info/firmware', value: _selectedValue);
    }
  }
}
