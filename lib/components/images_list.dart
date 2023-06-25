import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagesList extends StatefulWidget {
  const ImagesList({super.key});

  @override
  State<ImagesList> createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {
  late final List<String> _images = [];
  late final Future futureGetImages;

  Future<void> getImages() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images");
    final listResult = await imagesRef.list(
      const ListOptions(maxResults: 4),
    );
    for (var item in listResult.items) {
      final imageUrl = await storageRef.child(item.fullPath).getDownloadURL();
      _images.add(imageUrl);
    }
  }

  @override
  void initState() {
    super.initState();
    futureGetImages = getImages();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureGetImages,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            itemCount: _images.length < 4 ? _images.length : 4,
            itemBuilder: (context, index) {
              return Photo(imageUrl: _images[index]);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class Photo extends StatelessWidget {
  const Photo({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 2.5,
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 25.0),
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}
