import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/user/user.dart';
import 'package:vivarium_control_unit/ui/homepage/card_info.dart';
import 'package:vivarium_control_unit/ui/router.dart';
import 'package:vivarium_control_unit/ui/widgets/card/smallCard.dart';

class UserSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SmallCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blueGrey.shade700.withAlpha(120),
                        Colors.black.withAlpha(150)
                      ]),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  boxShadow: null),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                        child: Text(
                      '${Provider.of<VivariumUser>(context, listen: false).userEmail}',
                      style: Theme.of(context).textTheme.headline4,
                    )),
                    Divider(
                      height: 40,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, Routes.userDevices),
                        child: Center(
                          child: Text('Devices',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: CardInfo()),
          )
        ],
      ),
    );
  }
}
