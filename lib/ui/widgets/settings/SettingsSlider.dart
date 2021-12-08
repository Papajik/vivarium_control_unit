import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/utils/deviceProvider/deviceProvider.dart';

class SettingsSlider extends StatefulWidget {
  final String providerKey;
  final String title;
  final double value;
  final ValueChanged<double?>? onChanged;
  final ValueChanged<double?>? onChangeEnd;

  final double upLimit;
  final double lowLimit;

  final double max;
  final double min;
  final int division;

  final int precision;

  const SettingsSlider(
      {Key? key,
      required this.providerKey,
      required this.title,
      required this.value,
      this.onChanged,
      this.onChangeEnd,
      required this.max,
      this.precision = 1,
      required this.min,
      required this.division,
      required this.upLimit,
      required this.lowLimit})
      : super(key: key);

  @override
  _SettingsSliderState createState() => _SettingsSliderState();
}

class _SettingsSliderState extends State<SettingsSlider> {
  late double _val;

  @override
  void initState() {
    _val = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: Theme.of(context).textTheme.headline5),
                Text(_val.toStringAsFixed(widget.precision),
                    style: Theme.of(context).textTheme.headline5),
              ],
            ),
          ),
          Slider(
            onChanged: (value) {
              if (widget.onChanged != null) widget.onChanged!(value);
              if (widget.upLimit < value) value = widget.upLimit;
              if (widget.lowLimit > value) value = widget.lowLimit;
              setState(() {
                _val = value;
              });
            },
            onChangeEnd: (_) {
              if (widget.providerKey.isNotEmpty) {
                provider.saveValue(
                    key: widget.providerKey,
                    value:
                        double.parse(_val.toStringAsFixed(widget.precision)));
              }
              if (widget.onChangeEnd != null) widget.onChangeEnd!(_val);
            },
            value: _val,
            max: widget.max,
            min: widget.min,
            divisions: widget.division,
            label: _val.toStringAsFixed(widget.precision),
            activeColor: Colors.white,
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
