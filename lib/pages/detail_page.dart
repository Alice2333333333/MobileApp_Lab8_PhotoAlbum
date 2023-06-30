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
  late String dropdownFolderValue;
  late final imageDataProvider = context.read<ImageDataProvider>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    editMode = widget.editMode;
    imageData = widget.imageData;
    controllerDescr = TextEditingController(text: imageData.description);
    dropdownFolderValue =
        imageData.folder.isEmpty ? folders.first : imageData.folder;
  }

  @override
  void dispose() {
    controllerDescr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMMMEd().add_jms();
    final takenOn = format.format(imageData.timestamp.toDate());
    final latitude = imageData.location.latitude;
    final longitude = imageData.location.longitude;
    final location = "Latitude: $latitude\nLongitude: $longitude";
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.detailTitle),
            actions: [
              if (imageData.isUrl) ...[
                deleteButton(),
              ]
            ],
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
              detailText(
                "Description:",
                imageData.description,
                editMode: editMode,
              ),
              detailText(
                "Folder:",
                imageData.folder,
                editMode: editMode,
                dropdown: editMode,
              ),
              detailText(
                "Taken on:",
                takenOn,
              ),
              detailText(
                "Location:",
                location,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (editMode) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (imageData.isUrl) {
                  await updateData();
                } else {
                  await addData();
                }
              } else {
                setState(() => editMode = !editMode);
              }
            },
            icon: Icon(
              editMode ? Icons.save : Icons.edit,
            ),
            label: Text(
              editMode ? "Save" : "Edit",
            ),
          ),
        ),
        Positioned(
          child: isLoading ? const LoadingView() : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Future addData() async {
    setState(() => isLoading = true);
    UploadTask uploadTask = imageDataProvider.uploadFile(
      File(imageData.path),
      imageData.name,
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();

      final addInfo = {
        FirebaseConstants.description: controllerDescr.text,
        FirebaseConstants.timestamp: imageData.timestamp,
        FirebaseConstants.location: imageData.location,
        FirebaseConstants.folder: dropdownFolderValue,
        FirebaseConstants.url: imageUrl,
      };

      imageDataProvider.addDataFirestore(imageData.name, addInfo).then((data) {
        setState(() => isLoading = false);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Upload successful");
      }).catchError((err) {
        setState(() => isLoading = false);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() => isLoading = false);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future updateData() async {
    setState(() => isLoading = true);
    try {
      final updateInfo = {
        FirebaseConstants.description: controllerDescr.text,
        FirebaseConstants.folder: dropdownFolderValue,
      };

      imageDataProvider
          .updateDataFirestore(imageData.name, updateInfo)
          .then((data) {
        setState(() => isLoading = false);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Update successful");
      }).catchError((err) {
        setState(() => isLoading = false);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() => isLoading = false);
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future deleteData() async {
    setState(() => isLoading = true);
    Future deleteTask = imageDataProvider.deleteFile(imageData.name);
    try {
      imageDataProvider.deleteDataFirestore(imageData.name).then((data) async {
        await deleteTask;
        setState(() => isLoading = false);
        if (context.mounted) Navigator.of(context).pop();
        Fluttertoast.showToast(msg: "Delete successful");
      }).catchError((err) {
        setState(() => isLoading = false);
        if (context.mounted) Navigator.of(context).pop();
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() => isLoading = false);
      if (context.mounted) Navigator.of(context).pop();
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Widget detailText(
    String title,
    String text, {
    bool editMode = false,
    bool dropdown = false,
  }) {
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
          editMode
              ? dropdown
                  ? dropdownFolder()
                  : descriptionField()
              : Text(text),
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

  Widget dropdownFolder() {
    return DropdownButton<String>(
      isExpanded: true,
      value: dropdownFolderValue,
      onChanged: (String? value) {
        setState(() => dropdownFolderValue = value!);
      },
      items: folders.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  IconButton deleteButton() {
    return IconButton(
      icon: const Icon(
        Icons.delete_forever,
        color: Colors.redAccent,
      ),
      onPressed: () {
        _delete(context);
      },
    );
  }

  Future<void> _delete(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteData();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
