import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class OverviewCard extends StatelessWidget {
  final String title;
  final List<String> additionalHeaders;
  final Widget body;
  final Color background;

  const OverviewCard({Key key,
    this.title,
    this.additionalHeaders = const [],
    this.body,
    this.background = const Color(0xffeeeeee)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: background,
        elevation: 5,
        child: Column(
          children: [
            Container(
              color: Colors.cyan.shade200,
              height: 23,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  ...additionalHeaders.map((e) => Text(e)).toList()
                ],
              ),
            ),
            if (body != null) body
          ],
        ));
  }
}

class TriggerCardBody extends StatelessWidget {

  final Widget icon;
  final int nextTriggerTime;
  final Widget nextChange;

  /// Decide whether the next trigger exists.
  ///
  /// If this value is 'false' basic card will be drawn
  final bool hasTrigger;

  const TriggerCardBody(
      {Key key, this.icon, this.nextTriggerTime, this.nextChange, this.hasTrigger = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardBody(
      icon: icon,
      children: hasTrigger?[
        Text('Next trigger: ${getTimeStringFromTime(nextTriggerTime)}'),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [Text('Next change:'), nextChange],
        )
      ]:[
        Text('No triggers created')
      ],
    );
  }
}

class CardBody extends StatelessWidget {
  final Widget icon;
  final List<Widget> children;

  const CardBody({Key key, this.icon, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: icon),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ))
            ],
          ),
        ));
  }
}

