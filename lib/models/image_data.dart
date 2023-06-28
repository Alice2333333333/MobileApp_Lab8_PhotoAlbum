import 'package:cloud_firestore/cloud_firestore.dart';

List<String> collections = [
  "Travel",
  "Fashion",
  "Pet",
  "Sport",
];

class ImageData {
  ImageData({
    required this.path,
    required this.dateTime,
    required this.location,
    required this.name,
    this.description = "",
    this.collection = "",
    this.isUrl = true,
  });

  final String path;
  final String name;
  final String description;
  final String collection;
  final Timestamp dateTime;
  final GeoPoint location;
  final bool isUrl;
}
