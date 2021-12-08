import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/ui/homepage/card_auth.dart';
import 'package:vivarium_control_unit/ui/homepage/card_info.dart';
import 'package:vivarium_control_unit/ui/widgets/card/bigCard.dart';

class AnonymousBig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BigCard(
        child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.black.withAlpha(200),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30))),
              child: CardInfo()),
        ),
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blueGrey.shade700.withAlpha(150),
                      Colors.blueGrey.shade700.withAlpha(255)
                    ]),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CardAuth(width: 600),
            ),
          ),
        )
      ],
    ));
  }
}
