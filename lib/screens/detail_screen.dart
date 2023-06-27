import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  late bool editMode;
  late String description;
  late String datetime;
  late String location;
  late TextEditingController descrController;

  @override
  void initState() {
    super.initState();
    editMode = widget.editMode;
    description = widget.image.metadata!['description'] ?? '';
    datetime = widget.image.metadata!['datetime'] ?? '';
    location = widget.image.metadata!['location'] ?? '';
    descrController = TextEditingController(text: description);
  }

  @override
  void dispose() {
    descrController.dispose();
    super.dispose();
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
      ),
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
            description,
            editMode: editMode,
          ),
          infoText(
            "Taken on:",
            datetime,
          ),
          infoText(
            "Location:",
            location,
          ),
          infoText(
            "Collection:",
            widget.image.ref,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (editMode) {
            final storageRef = FirebaseStorage.instance.ref();
            final imageRef = storageRef.child(widget.image.ref);
            final newMetadata = SettableMetadata(
              customMetadata: {
                "description": descrController.text,
              },
            );
            await imageRef.updateMetadata(newMetadata);
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
