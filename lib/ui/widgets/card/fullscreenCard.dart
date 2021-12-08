import 'package:flutter/material.dart';

class FullscreenCard extends StatelessWidget {
  final Widget? child;
  final Color color;

  const FullscreenCard({Key? key, this.child, this.color = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 70, bottom: 10, left: 16.0, right: 16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
          shadowColor: Colors.black,
          color: color,
          child: child,
        ));
  }
}
