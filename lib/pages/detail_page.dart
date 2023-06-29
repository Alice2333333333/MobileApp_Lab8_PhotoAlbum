import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:photo_album/widgets/widgets.dart';
import 'package:photo_album/models/models.dart';
import 'package:photo_album/providers/providers.dart';
import 'package:photo_album/constants/constants.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.imageData,
    this.editMode = false,
  });

  final ImageData imageData;
  final bool editMode;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late bool editMode;
  late ImageData imageData;
  late TextEditingController controllerDescr;
  late final imageDataProvider = context.read<ImageDataProvider>();

  @override
  void initState() {
    super.initState();
    editMode = widget.editMode;
    imageData = widget.imageData;
    controllerDescr = TextEditingController(text: imageData.description);
  }

  @override
  void dispose() {
    controllerDescr.dispose();
    super.dispose();
  }

  Future uploadFile() async {
    UploadTask uploadTask = imageDataProvider.uploadFile(
      File(imageData.path),
      imageData.name,
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      final addInfo = {
        'description': controllerDescr.text,
        'datetime': imageData.dateTime,
        'location': imageData.location,
        'url': imageUrl,
      };

      imageDataProvider
          .addDataFirestore("folder1", imageData.name, addInfo)
          .then((data) {
        Fluttertoast.showToast(msg: "Upload success");
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future updateDetails() async {
    try {
      final updateInfo = {
        'description': controllerDescr.text,
      };

      imageDataProvider
          .updateDataFirestore("folder1", imageData.name, updateInfo)
          .then((data) {
        Fluttertoast.showToast(msg: "Update success");
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget infoText(String title, String text, {bool editMode = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 5.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          editMode ? descriptionField() : Text(text),
        ],
      ),
    );
  }

  TextField descriptionField() {
    return TextField(
      controller: controllerDescr,
      maxLines: 3,
      autofocus: true,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
          hintText: "Write something..."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.detailTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: 2.5,
          bottom: 75.0,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 2.5,
            ),
            child: imageData.isUrl
                ? CachedImage(imageUrl: imageData.path)
                : PickedImage(imagePath: imageData.path),
          ),
          infoText(
            "Description:",
            imageData.description,
            editMode: editMode,
          ),
          infoText(
            "Taken on:",
            DateFormat.yMMMEd().add_jms().format(imageData.dateTime.toDate()),
          ),
          infoText(
            "Location:",
            "Latitude: ${imageData.location.latitude}\nLongitude: ${imageData.location.longitude}",
          ),
          infoText(
            "Collection:",
            imageData.collection,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (editMode) {
            if (imageData.isUrl) {
              updateDetails();
            } else {
              uploadFile();
            }
            if (context.mounted) Navigator.pop(context);
          }
          setState(() {
            editMode = !editMode;
          });
        },
        icon: Icon(
          editMode ? Icons.save : Icons.edit,
        ),
        label: Text(
          editMode ? "Save" : "Edit",
        ),
      ),
    );
  }
}
