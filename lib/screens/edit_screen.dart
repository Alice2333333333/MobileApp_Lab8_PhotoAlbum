import 'dart:io';

import 'package:flutter/material.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Info"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 5.0,
            ),
            child: Image.file(
              File(imagePath),
              errorBuilder: (context, error, stackTrace) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: Icon(Icons.error),
              ),
            ),
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
