import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vivarium_control_unit/models/device/deviceCamera.dart';
import 'package:vivarium_control_unit/ui/device/camera/fullScreen.dart';

class DeviceViewSubpage extends StatefulWidget {
  final Camera camera;

  DeviceViewSubpage({Key key, this.camera}) : super(key: key);

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
    print('DeviceViewSubpage build');
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        child: Hero(
          tag: 'imageHero',
          child: buildBody(),
        ),
        onTap: _onTap(),
      ),
      color: Colors.lightBlue.shade200,
    );
  }

  @override
  void initState() {
    print('initState');
    createUrl();
    http
        .get(widget.camera.address)
        .then((response) {
          print('Response from init = ${response.toString()}');
          setState(() => _hasError = (response.statusCode != 200));
        })
        .catchError((value) => setState(()=>_hasError = false))
        .whenComplete(() => print('init - whenComplete'));
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
    print('didChangeDependencies');
    _timer?.cancel();
    tryToPreCache();
    _timer = Timer.periodic(Duration(seconds: 5),
        (Timer t) => {_param++, createUrl(), tryToPreCache()});
  }

  void tryToPreCache() {
    if (_hasError != null && _hasError) return;
    print('precache');
    print(_image);
    precacheImage(_image.image, context)
        .then((value) => mounted ? setState(() {}) : {});
  }

  void loadImage() {
    _image = Image(
      image: NetworkImage(_url),
      fit: BoxFit.contain,
    );
  }

  Widget buildBody() {
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

  void Function() _onTap() {
    if (_hasError == null) return null;
    if (_hasError) return null;
    return () {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return FullScreenView(
          address: widget.camera.address,
          param: _param,
        );
      }));
    };
  }

  void createUrl() {
    _url = '${widget.camera.address}?param=$_param&alt=media';
  }
}
