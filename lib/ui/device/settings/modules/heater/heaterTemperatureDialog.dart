import 'package:flutter/material.dart';

class HeaterTemperatureDialog extends StatefulWidget {
  final double? initialTemp;

  const HeaterTemperatureDialog({Key? key, required this.initialTemp})
      : super(key: key);

  @override
  _HeaterTemperatureDialogState createState() =>
      _HeaterTemperatureDialogState();
}

class _HeaterTemperatureDialogState extends State<HeaterTemperatureDialog> {
  double? g;

  @override
  void initState() {
    g = widget.initialTemp;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      backgroundColor: Colors.white,
      child: _content(context),
    );
  }

  Widget _content(context) {
    return Container(
      height: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text('New goal: $g °C', style: TextStyle(fontSize: 25)),
          ),
          Slider(
            onChanged: (value) {
              setState(() {
                g = value;
              });
            },
            value: g!,
            max: 35,
            min: 5,
            divisions: 60,
            label: '$g °C',
            activeColor: Colors.lightBlue,
            inactiveColor: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  onPressed: () => {Navigator.pop(context)},
                  child: Text('Cancel'),
                ),
              ),
              SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => {Navigator.pop(context, g)},
                  child: Text('Confirm'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
