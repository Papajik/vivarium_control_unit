import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/homepage/card_auth.dart';
import 'package:vivarium_control_unit/ui/homepage/card_info.dart';
import 'package:vivarium_control_unit/ui/widgets/card/smallCard.dart';

class AnonymousSmall extends StatelessWidget {
  final double width;

  const AnonymousSmall({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmallCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: _getFlex(width),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blueGrey.shade700.withAlpha(150),
                        Colors.black.withAlpha(200)
                      ]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(width>250?0:30),
                      bottomRight: Radius.circular(width>250?0:30),
                      topLeft: Radius.circular(30)),
                  boxShadow: null),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CardAuth(width: width),
              ),
            ),
          ),
          width > 250
              ? Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withAlpha(200),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: CardInfo()),
                )
              : SizedBox.shrink()
        ],
      ),
    );
  }

  int _getFlex(double width) {
    if (width > 320) return 1;
    if (width > 250) return 2;
    return 3;
  }
}
