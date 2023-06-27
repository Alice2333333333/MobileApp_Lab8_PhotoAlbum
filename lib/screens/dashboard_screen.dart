import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:photo_album/screens/detail_screen.dart';
import 'package:photo_album/components/images_list.dart';
import 'package:photo_album/components/expandable_fab.dart';
import 'package:photo_album/models/image_data.dart';

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

  void onPressedAction(BuildContext context, ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
      );

      final image = ImageData(
        path: pickedFile!.path,
        isUrl: false,
      );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              image: image,
              editMode: true,
            ),
          ),
        );
      }
    } catch (e) {
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
            onPressed: () => onPressedAction(
              context,
              ImageSource.camera,
            ),
            icon: const Icon(Icons.camera_alt),
          ),
          ActionButton(
            onPressed: () => onPressedAction(
              context,
              ImageSource.gallery,
            ),
            icon: const Icon(Icons.insert_photo),
          ),
        ],
      ),
    );
  }
}
