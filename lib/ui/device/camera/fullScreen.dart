import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenView extends StatefulWidget {
  final String? address;
  final int param;

  const FullScreenView({Key? key, this.address, required this.param}) : super(key: key);

  @override
  _FullScreenViewState createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  Timer? _timer;
  late String _url;
  late int _param;
  late Image _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: _image
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _param = widget.param;
    createUrl();
    _image = Image(
      image: NetworkImage(_url),
      fit: BoxFit.contain,
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_image.image, context);
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => {
              _param++,
              createUrl(),
              _image = Image(image: NetworkImage(_url), fit: BoxFit.contain),
              precacheImage(_image.image, context)
                  .then((value) => setState(() {}))
            });
  }

  void createUrl() {
    _url = '${widget.address}?param=$_param&alt=media';
  }
}
