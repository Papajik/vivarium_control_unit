import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class SettingsDropdown extends StatefulWidget {
  final String title;
  final Map<int, String> items;
  final int value;
  final String providerKey;
  final ValueChanged<int?>? onChanged;

  const SettingsDropdown(
      {Key? key,
      required this.title,
      required this.items,
      required this.value,
      required this.providerKey,
      this.onChanged})
      : super(key: key);

  @override
  _SettingsDropdownState createState() => _SettingsDropdownState();
}

class _SettingsDropdownState extends State<SettingsDropdown> {
  int? _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.headline5),
          Consumer<DeviceProvider>(
            builder: (context, provider, child) => DropdownButton<int>(
              value: _value,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ),
              style: Theme.of(context).textTheme.headline6,
              dropdownColor: Colors.black12,
              iconSize: 20,
              elevation: 16,
              items: widget.items.entries
                  .map((entry) => DropdownMenuItem<int>(
                      value: entry.key, child: Text(entry.value)))
                  .toList(),
              onChanged: (value) {
                if (widget.onChanged != null) widget.onChanged!(value);
                setState(() => _value = value);
                provider.saveValue(key: widget.providerKey, value: value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
