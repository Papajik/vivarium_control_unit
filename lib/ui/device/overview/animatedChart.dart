import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';

class AnimatedChart extends StatefulWidget {
  final List<Map<DateTime, double>?> lines;
  final List<Color> colors;
  final List<String> units;
  final double height = 160;
  final double width = 200;
  final Color backgroundColor;

  const AnimatedChart(
      {Key? key,
      required this.lines,
      required this.colors,
      required this.units,
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  _AnimatedChartState createState() => _AnimatedChartState();
}

class _AnimatedChartState extends State<AnimatedChart> {
  LineChart? chart;

  @override
  void initState() {
    var isEmpty = false;
    widget.lines.forEach((element) {
      if (element!.length < 2) isEmpty = true;
    });

    if (!isEmpty) {
      chart = LineChart.fromDateTimeMaps(
          widget.lines as List<Map<DateTime, double>>,
          widget.colors,
          widget.units,
          tapTextFontWeight: FontWeight.w400);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return chart == null
        ? Center(
            child: Text('Not enough data for graph',
                style: Theme.of(context).textTheme.headline4))
        : Container(
            color: widget.backgroundColor,
            child: SizedBox(
                height: widget.height,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, left: 8, right: 8, bottom: 5),
                  child: AnimatedLineChart(
                    chart!,
                    textStyle: TextStyle(color: Colors.blueAccent.shade200),
                    gridColor: Colors.grey.shade400,
                    key: UniqueKey(),
                    toolTipColor: Colors.white,
                  ), //Unique key to force animations
                )),
          );
  }
}
