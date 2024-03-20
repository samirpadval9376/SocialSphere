import 'package:flutter/material.dart';

class TextPost extends StatelessWidget {
  final String text;

  const TextPost({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.indigo.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }
}
