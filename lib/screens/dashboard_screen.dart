import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:photo_album/screens/detail_screen.dart';
import 'package:photo_album/components/images_list.dart';
import 'package:photo_album/components/expandable_fab.dart';
import 'package:photo_album/models/image_data.dart';
import 'package:photo_album/services/location.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future getImage(BuildContext context, ImageSource source) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: source).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
        return null;
      });
      final position = await determinePosition();
      final image = ImageData(
        path: pickedFile!.path,
        name: pickedFile.name,
        dateTime: DateFormat.yMMMEd().add_jms().format(DateTime.now()),
        location: position.toString(),
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
      ),
      body: const ImagesList(),
      floatingActionButton: ExpandableFab(
        distance: 75,
        children: [
          ActionButton(
            onPressed: () => getImage(
              context,
              ImageSource.camera,
            ),
            icon: const Icon(Icons.camera_alt),
          ),
          ActionButton(
            onPressed: () => getImage(
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
