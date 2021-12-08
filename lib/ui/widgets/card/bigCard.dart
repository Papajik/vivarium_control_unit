import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final Widget? child;
  final Color color;
  final double maxHeight;
  final double ratio;

  const BigCard(
      {Key? key,
      this.child,
      this.color = Colors.transparent,
      this.maxHeight = 400,
      this.ratio = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: AspectRatio(
              aspectRatio: ratio,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 2,
                shadowColor: Colors.black,
                color: color,
                child: child,
              ),
            )));
  }
}
