import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:photo_album/components/image_caller.dart';
import 'package:photo_album/models/image_data.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.image,
    this.editMode = false,
  });

  final ImageData image;
  final bool editMode;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late bool editMode;
  late List<String> location;
  late TextEditingController descrController;

  @override
  void initState() {
    super.initState();
    editMode = widget.editMode;
    descrController = TextEditingController(text: widget.image.description);
    location = widget.image.location.split(", ");
  }

  @override
  void dispose() {
    descrController.dispose();
    super.dispose();
  }

  Future uploadFile() async {
    try {
      final ref = storage.ref().child(widget.image.name);
      await ref.putFile(File(widget.image.path));
      final imageUrl = await ref.getDownloadURL();
      final folder1 = firestore.collection('folder1');
      folder1.add({
        'description': descrController.text,
        'datetime': widget.image.dateTime,
        'location': widget.image.location,
        'url': imageUrl,
      }).then((doc)async {
        Fluttertoast.showToast(msg: "Upload success");
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
      controller: descrController,
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
        title: const Text("Detail Info"),
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
            child: widget.image.isUrl
                ? CachedImage(imageUrl: widget.image.path)
                : PickedImage(imagePath: widget.image.path),
          ),
          infoText(
            "Description:",
            widget.image.description,
            editMode: editMode,
          ),
          infoText(
            "Taken on:",
            widget.image.dateTime,
          ),
          infoText(
            "Location:",
            "${location[0]}\n${location[1]}",
          ),
          if (widget.image.isUrl) ...[
            infoText(
              "Collection:",
              widget.image.collection,
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (editMode) {
            if (widget.image.isUrl) {
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
