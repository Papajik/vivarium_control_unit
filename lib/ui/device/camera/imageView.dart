import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vivarium_control_unit/models/cameraImage/cameraImage.dart';

class ImageView extends StatefulWidget {
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _fullscreen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          if (_fullscreen) {
            portrait();
            setState(() {
              _fullscreen = false;
            });
          } else {
            landscape();
            setState(() => _fullscreen = true);
          }
        },
        child: _fullscreen
            ? Hero(
                tag: 'imageHero',
                child: Consumer<CameraImage?>(
                  builder: (context, image, child) {
                    return Image.memory(
                      image!.data!,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                    );
                  },
                ))
            : Hero(
                tag: 'imageHero',
                child: Consumer<CameraImage?>(
                  builder: (context, image, child) {
                    if (image == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (image.data == null) {
                      return Center(
                          child: Card(
                              child: Container(
                                  height: 50,
                                  width: 200,
                                  child: Center(
                                      child: Text('No photo available yet')))));
                    }
                    return Image.memory(
                      image.data!,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                    );
                  },
                ),
              ),
      ),
    );
  }

  Future<void> landscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> portrait() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    portrait();
    super.dispose();
  }
}
