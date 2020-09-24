import 'dart:async';

import 'package:flutter/material.dart';

class FullScreenView extends StatefulWidget {
  final String address;
  final int param;

  const FullScreenView({Key key, this.address, this.param}) : super(key: key);

  @override
  _FullScreenViewState createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  Timer _timer;
  String _url;
  int _param;
  Image _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: _image
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void initState() {
    _param = widget.param;
    _url = "${widget.address}&param=$_param";
    _image = Image(
      image: NetworkImage(_url),
      fit: BoxFit.contain,
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(_image.image, context);
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = new Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => {
              _param++,
              _url = "${widget.address}&param=$_param",
              _image = Image(image: NetworkImage(_url), fit: BoxFit.contain),
              precacheImage(_image.image, context)
                  .then((value) => setState(() {}))
            });
  }
}
