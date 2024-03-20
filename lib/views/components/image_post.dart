import 'package:flutter/material.dart';

class ImagePost extends StatelessWidget {
  final String text;
  final String url;

  const ImagePost({super.key, required this.text, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
