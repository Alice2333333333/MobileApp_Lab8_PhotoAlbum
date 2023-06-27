class ImageData {
  ImageData({
    required this.path,
    this.metadata,
    this.ref = "images",
    this.isUrl = true,
  });

  final String path;
  final Map<String, String>? metadata;
  final String ref;
  final bool isUrl;
}
