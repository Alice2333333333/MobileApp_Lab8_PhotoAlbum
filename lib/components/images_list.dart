import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:photo_album/models/image_data.dart';
import 'package:photo_album/components/cached_image.dart';
import 'package:photo_album/screens/detail_screen.dart';

class ImagesList extends StatefulWidget {
  const ImagesList({super.key});

  @override
  State<ImagesList> createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {
  late final List<ImageData> _images = [];
  late final Future futureGetImages;

  Future<void> getImages() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("images");
    final listResult = await imagesRef.list(
      const ListOptions(maxResults: 4),
    );
    for (var item in listResult.items) {
      final itemRef = storageRef.child(item.fullPath);
      final imageUrl = await itemRef.getDownloadURL();
      final metadata = await itemRef.getMetadata();
      final image = ImageData(
        path: item.fullPath,
        url: imageUrl,
        metadata: metadata.customMetadata,
      );
      _images.add(image);
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
              return Photo(
                imageUrl: _images[index].url,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(image: _images[index]),
                  ),
                ),
              );
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
