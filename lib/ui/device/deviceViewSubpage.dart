import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/ui/device/fullScreen.dart';

class DeviceViewSubpage extends StatefulWidget {
  final Device device;
  final String userId;

  DeviceViewSubpage({Key key, this.device, this.userId}) : super(key: key);

  @override
  _DeviceViewSubpageState createState() => _DeviceViewSubpageState();
}

class _DeviceViewSubpageState extends State<DeviceViewSubpage> {
  Timer _timer;

  // Key _key;
  String _url;
  int _param = 0;
  Image _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        child: Hero(
          tag: "imageHero",
          child: _image,
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return FullScreenView(
              address: widget.device.camera.address,
              param: _param,
            );
          }));
        },
      ),
      color: Colors.lightBlue.shade200,
    );
  }

  @override
  void initState() {
    _url = "${widget.device.camera.address}&param=$_param";
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
              _url = "${widget.device.camera.address}&param=$_param",
              _image = Image(image: NetworkImage(_url), fit: BoxFit.contain),
              precacheImage(_image.image, context)
                  .then((value) => setState(() {}))
            });
  }
}
