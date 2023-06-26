import 'package:flutter/material.dart';

import 'package:photo_album/components/cached_image.dart';
import 'package:photo_album/models/image_data.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.image,
  });

  final ImageData image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Info"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 5.0,
            ),
            child: CachedImage(imageUrl: image.url),
          ),
          Text("Description:"),
          Text("Location:"),
          Text("Date:"),
          Text("Time:"),
          Text("Local path:"),
        ],
      ),
    );
  }
}
