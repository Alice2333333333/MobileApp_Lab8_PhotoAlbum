import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isRear = true;

  Future takePhoto() async {
    // if (!_cameraController.value.isInitialized) {
    //   return null;
    // }
    // if (_cameraController.value.isTakingPicture) {
    //   return null;
    // }
    // try {
    //   await _cameraController.setFlashMode(FlashMode.off);
    //   XFile picture = await _cameraController.takePhoto();
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => PreviewPage(
    //                 picture: picture,
    //               )));
    // } on CameraException catch (e) {
    //   debugPrint('Error occured while taking picture: $e');
    //   return null;
    // }
  }

  void initCamera(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.max);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras[0]);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Row(
                children: [
                  const Spacer(),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: takePhoto,
                        iconSize: 70,
                        icon: const Icon(
                          Icons.circle,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 30,
                      icon: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _isRear = !_isRear;
                        initCamera(widget.cameras[_isRear ? 0 : 1]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
