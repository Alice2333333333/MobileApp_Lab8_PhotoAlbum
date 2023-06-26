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
          const InfoText(
            title: "Description:",
            text: "abc",
          ),
          const InfoText(
            title: "Location:",
            text: "abc",
          ),
          const InfoText(
            title: "Date:",
            text: "abc",
          ),
          const InfoText(
            title: "Time:",
            text: "abc",
          ),
          const InfoText(
            title: "Local path:",
            text: "abc",
          ),
        ],
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
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
          Text(text),
        ],
      ),
    );
  }
}
