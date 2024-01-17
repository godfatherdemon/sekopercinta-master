import 'dart:io';

// import 'package:camerawesome/models/orientations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

import 'package:path_provider/path_provider.dart';
import 'package:camerawesome/camerawesome_plugin.dart';


import 'package:sekopercinta/components/custom_button/camera_button.dart';

class CameraPage extends StatefulWidget {
  // just for E2E test. if true we create our images names from datetime.
  // Else it's just a name to assert image exists

  final bool randomPhotoName;

  CameraPage({this.randomPhotoName = true});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  late String _lastPhotoPath;
  bool _isRecordingVideo = false;
  IconData _flashIcon = Icons.flash_auto;

  // ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.AUTO);
  ValueNotifier<double> _zoomNotifier = ValueNotifier(0);
  // ValueNotifier<Size?> _photoSize = ValueNotifier(null);
  ValueNotifier<Size> _photoSize =
      ValueNotifier(Size(0, 0)); // Initialize with a default Size
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.back);
  ValueNotifier<CaptureMode> _captureMode = ValueNotifier(CaptureMode.photo);
  ValueNotifier<bool> _enableAudio = ValueNotifier(true);
  ValueNotifier<CameraOrientations> _orientation =
      ValueNotifier(CameraOrientations.portrait_up);

  /// use this to call a take picture
  // PictureController _pictureController = new PictureController();

  @override
  void dispose() {
    // previewStreamSub.cancel();
    _photoSize.dispose();
    _captureMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          buildFullscreenCamera(),
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                SizedBox(
                  height: 202,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _flashIcon,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // switch (_switchFlash.value) {
                                  //   case CameraFlashes.NONE:
                                  //     _switchFlash.value = CameraFlashes.ON;
                                  //     break;
                                  //   case CameraFlashes.ON:
                                  //     _switchFlash.value = CameraFlashes.AUTO;
                                  //     break;
                                  //   case CameraFlashes.AUTO:
                                  //     _switchFlash.value = CameraFlashes.ALWAYS;
                                  //     break;
                                  //   case CameraFlashes.ALWAYS:
                                  //     _switchFlash.value = CameraFlashes.NONE;
                                  //     break;
                                  // }

                                  setState(() {
                                    // _flashIcon = _getFlashIcon();
                                  });
                                },
                              ),
                              CameraButton(
                                key: ValueKey('cameraButton'),
                                captureMode: _captureMode.value,
                                isRecording: _isRecordingVideo,
                                onTap: _takePhoto,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (_sensor.value == Sensors.front) {
                                    _sensor.value = Sensors.back;
                                  } else {
                                    _sensor.value = Sensors.front;
                                  }
                                },
                                icon: Icon(
                                  Icons.flip_camera_ios_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // IconData _getFlashIcon() {
  //   switch (_switchFlash.value) {
  //     case CameraFlashes.NONE:
  //       return Icons.flash_off;
  //     case CameraFlashes.ON:
  //       return Icons.flash_on;
  //     case CameraFlashes.AUTO:
  //       return Icons.flash_auto;
  //     case CameraFlashes.ALWAYS:
  //       return Icons.highlight;
  //     default:
  //       return Icons.flash_off;
  //   }
  // }

  _takePhoto() async {
    final Directory extDir = await getTemporaryDirectory();
    final testDir =
        await Directory('${extDir.path}/test').create(recursive: true);
    final String filePath = widget.randomPhotoName
        ? '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'
        : '${testDir.path}/photo_test.jpg';
    // await _pictureController.takePicture(filePath);
    // lets just make our phone vibrate
    HapticFeedback.mediumImpact();
    _lastPhotoPath = filePath;

    File rotatedImage =
        await FlutterExifRotation.rotateImage(path: _lastPhotoPath);

    Navigator.of(context).pop(rotatedImage.path);
  }

  _onOrientationChange(CameraOrientations? newOrientation) {
    _orientation.value = newOrientation!;
  }

  _onPermissionsResult(bool? granted) {
    if (!granted!) {
      AlertDialog alert = AlertDialog(
        title: Text('Error'),
        content: Text(
            'It seems you doesn\'t authorized some permissions. Please check on your settings and try again.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    } else {
      setState(() {});
      print("granted");
    }
  }

  // /// this is just to preview images from stream
  // /// This use a bufferTime to take an image each 1500 ms
  // /// you cannot show every frame as flutter cannot draw them fast enough
  // /// [THIS IS JUST FOR DEMO PURPOSE]
  // Widget _buildPreviewStream() {
  //   if (previewStream == null) return Container();
  //   return Positioned(
  //     left: 32,
  //     bottom: 120,
  //     child: StreamBuilder(
  //       stream: previewStream.bufferTime(Duration(milliseconds: 1500)),
  //       builder: (context, snapshot) {
  //         print(snapshot);
  //         if (!snapshot.hasData || snapshot.data == null) return Container();
  //         List<Uint8List> data = snapshot.data;
  //         print(
  //             "...${DateTime.now()} new image received... ${data.last.lengthInBytes} bytes");
  //         return Image.memory(
  //           data.last,
  //           width: 120,
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildFullscreenCamera() {
    return Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      right: 0,
      child: Center(
          // child: CameraAwesome(
          //   onPermissionsResult: _onPermissionsResult,
          //   captureMode: _captureMode,
          //   photoSize: _photoSize,
          //   sensor: _sensor,
          //   enableAudio: _enableAudio,
          //   switchFlashMode: _switchFlash,
          //   zoom: _zoomNotifier,
          //   onOrientationChanged: _onOrientationChange,
          //   selectDefaultSize: (availableSizes) {
          //     // _photoSize.value = availableSizes.last;
          //     // setState(() {});

          //     final size =
          //         availableSizes.where((size) => size.width <= 1024).toList()[0];
          //     _photoSize.value = size; // Assign the selected size to _photoSize

          //     return size;
          //   },
          //   onCameraStarted: () {
          //     // camera started here -- do your after start stuff
          //   },
          // ),
          ),
    );
  }
}
