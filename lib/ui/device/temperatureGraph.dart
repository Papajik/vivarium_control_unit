import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/sensorData.dart';

class TemperatureGraph extends StatefulWidget {
  final String deviceId;
  final String userId;
  final double minTemperature = -10;

  TemperatureGraph({Key key, this.deviceId, this.userId}) : super(key: key);

  @override
  _TemperatureGraphPage createState() => _TemperatureGraphPage();
}

class _TemperatureGraphPage extends State<TemperatureGraph> {
  double _showLastMinutes = 60;
  DateTime _time;
  Map<String, num> _temps = <String, num>{};

  @override
  Widget build(BuildContext context) {
    _onChangedListener(charts.SelectionModel model) {
      print("change");
      final selectedDatum = model.selectedDatum;
      DateTime time;
      final temps = <String, num>{};
      if (selectedDatum.isNotEmpty) {
        time = selectedDatum.first.datum.updateTime.toDate();

        selectedDatum.forEach((charts.SeriesDatum datumPair) {
          if (datumPair.datum.temp1 > widget.minTemperature) {
            temps["temp1"] = datumPair.datum.temp1;
          }
          if (datumPair.datum.temp2 > widget.minTemperature) {
            temps["temp2"] = datumPair.datum.temp2;
          }
        });
      }

      // Request a build.
      setState(() {
        _time = time;
        _temps = temps;
        _showLastMinutes = _showLastMinutes;
      });
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("Temperature"),
          Container(
            height: 200,
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("users")
                    .document(widget.userId)
                    .collection("deviceHistories")
                    .document(widget.deviceId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<SensorData> data = List();
                  var history = snapshot.data['sensorValuesHistory'];
                  var it;
                  for (it in history) {
                    data.add(
                        SensorData.fromJSON(Map<String, dynamic>.from(it)));
                  }
                  List<charts.Series> seriesList = _createSeriesList(data);

                  return new charts.TimeSeriesChart(
                    seriesList,
                    animate: false,
                    animationDuration: Duration(seconds: 1),
                    behaviors: [
                      charts.LinePointHighlighter(
                          symbolRenderer: charts.CircleSymbolRenderer())
                    ],
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                        tickProviderSpec:
                            new charts.BasicNumericTickProviderSpec(
                      zeroBound: false,
                    )),
                    selectionModels: [
                      charts.SelectionModelConfig(
                        type: charts.SelectionModelType.info,
                        changedListener: _onChangedListener,
                      ),
                    ],
                  );
                }),
          ),
          Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child:
                (_time != null) ? Text("Time: " + _time.toString()) : Text(""),
          ),
          (_temps['temp1'] != null)
              ? Text(
                  "Temperature 1: " + _temps['temp1'].round().toString() + "°C")
              : Text(""),
          (_temps['temp2'] != null)
              ? Text(
                  "Temperature 2: " + _temps['temp2'].round().toString() + "°C")
              : Text(""),
          Slider(
            value: _showLastMinutes,
            min: 10,
            max: 360,
            onChanged: (double newValue) {
              setState(() {
                print("slider");
                _time = _time;
                _temps = _temps;
                _showLastMinutes = newValue;
              });
            },
          ),
          Text("Display last " +
              _showLastMinutes.round().toString() +
              " minutes")
        ],
      ),
    );
  }

  List<charts.Series<SensorData, DateTime>> _createSeriesList(
      List<SensorData> data) {
    DateTime now = DateTime.now();

    List<SensorData> filtered = data
        .where((e) => e.updateTime.toDate().isAfter(new DateTime(
            now.year,
            now.month,
            now.day,
            now.hour,
            now.minute - _showLastMinutes.round())))
        .toList();

    List<SensorData> filteredTemp1 =
        filtered.where((e) => e.temp1 > widget.minTemperature).toList();
    List<SensorData> filteredTemp2 =
        filtered.where((e) => e.temp2 > widget.minTemperature).toList();

    return [
      new charts.Series<SensorData, DateTime>(
        id: "Temp1",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (SensorData data, _) => data.updateTime.toDate(),
        measureFn: (SensorData data, _) => data.temp1,
        data: filteredTemp1,
      ),
      new charts.Series<SensorData, DateTime>(
        id: "Temp2",
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (SensorData data, _) => data.updateTime.toDate(),
        measureFn: (SensorData data, _) => data.temp2,
        data: filteredTemp2,
      )
    ];
  }
}
