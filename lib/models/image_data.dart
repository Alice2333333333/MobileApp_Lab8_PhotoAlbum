class ImageData {
  ImageData({
    required this.path,
    required this.url,
    this.metadata,
  });

  final String path;
  final String url;
  final Map<String, String>? metadata;
}
