import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class SettingsNumberInput extends StatefulWidget {
  final String title;
  final String providerKey;
  final double initValue;
  final ValueChanged<double?>? onChanged;

  const SettingsNumberInput(
      {Key? key,
      required this.title,
      required this.providerKey,
      this.onChanged,
      required this.initValue})
      : super(key: key);

  @override
  _SettingsNumberState createState() => _SettingsNumberState();
}

class _SettingsNumberState extends State<SettingsNumberInput> {
  TextEditingController textArea = TextEditingController();

  @override
  void initState() {
    textArea.text = widget.initValue.toStringAsFixed(2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.title, style: Theme.of(context).textTheme.headline5),
          Container(
            width: 100,
            child: Consumer<DeviceProvider>(
                builder: (context, provider, child) => TextField(
                      keyboardType: TextInputType.number,
                      controller: textArea,
                      onSubmitted: (value) {
                        if (widget.onChanged != null)
                          widget.onChanged!(double.parse(value));
                        provider.saveValue(key: widget.providerKey, value: double.parse(value));
                      },
                    )),
          ),
        ],
      ),
    );
  }
}
