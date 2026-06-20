import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final String text;

  const StoryCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          height: 1.5,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
