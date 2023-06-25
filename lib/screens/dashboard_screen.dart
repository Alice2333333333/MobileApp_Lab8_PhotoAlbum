import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';

import 'package:photo_album/screens/camera_screen.dart';
import 'package:photo_album/screens/gallery_screen.dart';
import 'package:photo_album/components/images_list.dart';
import 'package:photo_album/components/expandable_fab.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void saveData() async {
    final storageRef = FirebaseStorage.instance.ref();
    final mountainRef = storageRef.child("images/mountains.jpg");

    try {
      final ByteData bytes = await rootBundle.load('assets/mountains.jpg');
      final Uint8List data = bytes.buffer.asUint8List();
      final customMetadata = SettableMetadata(
        customMetadata: {
          "location": "Yosemite, CA, USA",
          "activity": "Hiking",
        },
      );
      await mountainRef.putData(data, customMetadata);
      final metadata = await mountainRef.getMetadata();
      log(metadata.customMetadata.toString());
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo Album"),
        automaticallyImplyLeading: false,
      ),
      body: const ImagesList(),
      floatingActionButton: ExpandableFab(
        distance: 75,
        children: [
          ActionButton(
            onPressed: () async {
              await availableCameras().then(
                (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(cameras: value),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.camera_alt),
          ),
          ActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GalleryScreen(),
              ),
            ),
            icon: const Icon(Icons.insert_photo),
          ),
        ],
      ),
    );
  }
}
