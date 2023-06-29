import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:photo_album/pages/pages.dart';
import 'package:photo_album/widgets/widgets.dart';
import 'package:photo_album/models/models.dart';
import 'package:photo_album/providers/providers.dart';
import 'package:photo_album/services/services.dart';
import 'package:photo_album/constants/constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final ImageDataProvider imageDataProvider =
      context.read<ImageDataProvider>();

  Future getImage(BuildContext context, ImageSource source) async {
    final pickedFile =
        await ImagePicker().pickImage(source: source).catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
      return null;
    });
    final dateTime = Timestamp.fromDate(DateTime.now());
    final position = await determinePosition();
    final location = GeoPoint(
      position.latitude,
      position.longitude,
    );
    final imageData = ImageData(
      path: pickedFile!.path,
      name: pickedFile.name,
      dateTime: dateTime,
      location: location,
      isUrl: false,
    );
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(
            imageData: imageData,
            editMode: true,
          ),
        ),
      );
    }
  }

  Widget buildListImage() {
    return StreamBuilder<QuerySnapshot>(
      stream: imageDataProvider.getImageStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.hasData) {
          final listImage = snapshot.data!.docs;
          if (listImage.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              itemCount: listImage.length,
              itemBuilder: (context, index) => Photo(
                  imageUrl: listImage[index].get("url"), onTap: () {}
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => DetailPage(imageData: _images[index]),
                  //   ),
                  // ),
                  ),
            );
          } else {
            return const Center(
              child: Text("No image here yet..."),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.dashboardTitle),
      ),
      body: buildListImage(),
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

class Photo extends StatelessWidget {
  const Photo({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 2.5,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: CachedImage(imageUrl: imageUrl),
      ),
    );
  }
}
