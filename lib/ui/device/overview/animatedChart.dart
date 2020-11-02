import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:flutter/material.dart';

class AnimatedChart extends StatefulWidget {
  final List<Map<DateTime, double>> lines;
  final List<Color> colors;
  final List<String> units;
  final double height = 160;
  final double width = 200;
  final Color backgroundColor  = Colors.white;

  const AnimatedChart(
      {Key key,
      @required this.lines,
      @required this.colors,
      @required this.units,
      })
      : super(key: key);

  @override
  _AnimatedChartState createState() => _AnimatedChartState();
}

class _AnimatedChartState extends State<AnimatedChart> {
  LineChart chart;

  @override
  void initState() {
    chart = LineChart.fromDateTimeMaps(
        widget.lines, widget.colors, widget.units,
        tapTextFontWeight: FontWeight.w400);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 8, right:8, bottom: 5),
            child: AnimatedLineChart(
              chart,
              key: UniqueKey(),
            ), //Unique key to force animations
          )),
    );
  }
}
