import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  final Widget? child;
  final Color color;
  const SmallCard({Key? key, this.child, this.color = Colors.transparent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: AspectRatio(
              aspectRatio: 2 / 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, bottom: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 2,
                  shadowColor: Colors.black,
                  color: color,
                  child: child,
                ),
              ),
            )));
  }
}
