import 'dart:math';

import 'package:flutter/material.dart';

class IconRotation extends StatefulWidget {
  final double speed;
  final Widget icon;

  const IconRotation({Key key,@required this.icon, this.speed =  0}) : super(key: key);

  @override
  _IconRotationState createState() => _IconRotationState();
}

class _IconRotationState extends State<IconRotation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: 60), upperBound: pi * 2)
      ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.rotate(
        angle: _animationController.value * widget.speed,
        child: child,
      ),
      child: widget.icon,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
