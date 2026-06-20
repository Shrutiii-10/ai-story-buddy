import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool disabled;

  const OptionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    if (isSelected) {
      if (isCorrect) {
        bgColor = Colors.green.shade300;
      } else if (isWrong) {
        bgColor = Colors.red.shade300;
      } else {
        bgColor = Colors.blue.shade200;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Semantics(
        button: true,
        label: "Option $text",
        child: InkWell(
          onTap: disabled
              ? null
              : () {
                  HapticFeedback.lightImpact();
                  onTap();
                },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected && isWrong ? Colors.red : Colors.blue.shade100,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
