import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vivarium_control_unit/models/device.dart';
import 'package:vivarium_control_unit/ui/device/camera/fullScreen.dart';

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
  bool _hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        child: Hero(
          tag: "imageHero",
          child: buildBody(),
        ),
        onTap: _onTap(),
      ),
      color: Colors.lightBlue.shade200,
    );
  }

  @override
  void initState() {
    createUrl();
    http
        .get(_url)
        .then((value) => setState(() => _hasError = value.statusCode != 200));
    loadImage();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
    _timer?.cancel();
    tryToPreCache();

    _timer = new Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => {
              _param++,
             createUrl(),
              tryToPreCache()
            });
  }

  tryToPreCache() {
    if (_hasError != null && _hasError) return;
    print("precache");
    print(_image);
    precacheImage(_image.image, context)
        .then((value) => mounted ? setState(() {}) : {});
  }

  loadImage() {
    _image = Image(
      image: NetworkImage(_url),
      fit: BoxFit.contain,
    );
  }

  buildBody() {
    if (_hasError == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_hasError) {
      return Text("Couldn't load image");
    } else {
      return _image;
    }
  }

  _onTap() {
    if (_hasError == null) return null;
    if (_hasError) return null;
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return FullScreenView(
          address: widget.device.camera.address,
          param: _param,
        );
      }));
    };
  }

  void createUrl() {
    _url = "${widget.device.camera.address}?param=$_param&alt=media";
  }
}
