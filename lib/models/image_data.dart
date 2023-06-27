import 'package:geolocator/geolocator.dart';

class ImageData {
  ImageData({
    required this.path,
    required this.dateTime,
    required this.location,
    this.name = "",
    this.description = "",
    this.collection = "",
    this.isUrl = true,
  });

  final String path;
  final String name;
  final String description;
  final String dateTime;
  final String collection;
  final String location;
  final bool isUrl;
}
