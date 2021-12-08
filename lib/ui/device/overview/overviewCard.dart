import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/utils/converters.dart';

class OverviewCard extends StatelessWidget {
  final String? title;
  final List<String> additionalHeaders;
  final Widget? additionalHeader;
  final Widget? body;
  final Color background;
  final Color? titleBackground;

  const OverviewCard(
      {Key? key,
      this.title,
      this.additionalHeaders = const [],
      this.body,
      this.titleBackground,
      this.background = Colors.transparent,
      this.additionalHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.black12,
          elevation: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    gradient: LinearGradient(colors: [
                      Theme.of(context).accentColor,
                      titleBackground ?? Theme.of(context).accentColor
                    ], stops: [
                      0.6,
                      1
                    ])),
                // color: titleBackground ?? Theme.of(context).accentColor,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title!, style: Theme.of(context).textTheme.headline5),
                      if (additionalHeader != null) additionalHeader!,
                      ...additionalHeaders
                          .map((e) => Text(e,
                              style: Theme.of(context).textTheme.headline6))
                          .toList()
                    ],
                  ),
                ),
              ),
              if (body != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: body,
                )
            ],
          )),
    );
  }
}

class TriggerCardBody extends StatelessWidget {
  final Widget? icon;
  final int? nextTriggerTime;
  final Widget? nextChange;

  /// Decide whether the next trigger exists.
  ///
  /// If this value is 'false' basic card will be drawn
  final bool hasTrigger;

  const TriggerCardBody(
      {Key? key,
      this.icon,
      this.nextTriggerTime,
      this.nextChange,
      this.hasTrigger = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardBody(
      icon: icon,
      children: hasTrigger
          ? [
              Text('Next trigger: ${getTimeStringFromTime(nextTriggerTime)}'),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Next change:'), nextChange!],
              )
            ]
          : [Text('No triggers created')],
    );
  }
}

class CardBody extends StatelessWidget {
  final Widget? icon;
  final List<Widget>? children;

  const CardBody({Key? key, this.icon, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: icon),
        Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: children!,
              ),
            ))
      ],
    );
  }
}
