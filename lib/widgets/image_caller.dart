import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      errorWidget: (context, url, error) => const ErrorIcon(),
    );
  }
}

class PickedImage extends StatelessWidget {
  const PickedImage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
      errorBuilder: (context, error, stackTrace) => const ErrorIcon(),
    );
  }
}

class ErrorIcon extends StatelessWidget {
  const ErrorIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: Icon(Icons.error),
    );
  }
}
