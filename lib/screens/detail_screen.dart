import 'dart:developer';

import 'package:flutter/material.dart';

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
  late bool editMode = widget.editMode;

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
          editMode ? descriptionField(text) : Text(text),
        ],
      ),
    );
  }

  TextFormField descriptionField(String text) {
    return TextFormField(
      initialValue: text,
      maxLines: 3,
      autofocus: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.all(8.0),
      ),
      onChanged: (value) {
        log(value);
      },
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
            "abc",
            editMode: editMode,
          ),
          infoText(
            "Location:",
            "abc",
          ),
          infoText(
            "Date:",
            "abc",
          ),
          infoText(
            "Time:",
            "abc",
          ),
          infoText(
            "Local path:",
            "abcooooooooooooooooooooooooooo",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (editMode) {
            log("save");
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
