import 'package:cloud_firestore/cloud_firestore.dart';

final List<String>folders = List.unmodifiable([
  "General",
  "Travel",
  "Fashion",
  "Pet",
  "Sport",
]);

class ImageData {
  ImageData({
    required this.path,
    required this.timestamp,
    required this.location,
    required this.name,
    this.folder = "",
    this.description = "",
    this.isUrl = true,
  });

  final String path;
  final String name;
  final String description;
  final String folder;
  final Timestamp timestamp;
  final GeoPoint location;
  final bool isUrl;
}
