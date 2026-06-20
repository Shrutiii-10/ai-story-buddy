import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';

class AiBuddy extends ConsumerWidget {
  const AiBuddy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final quizState = ref.watch(quizProvider);

    String emoji = "🤖"; // Default Idle
    Color bgColor = Colors.blue.shade100;

    if (quizState.status == QuizStatus.correctAnswer) {
      emoji = "🤩"; // Happy
      bgColor = Colors.green.shade100;
    } else if (quizState.status == QuizStatus.wrongAnswer) {
      emoji = "🥺"; // Sad
      bgColor = Colors.grey.shade300;
    } else if (audioState == AudioState.playing) {
      emoji = "📖"; // Reading
      bgColor = Colors.purple.shade100;
    } else if (audioState == AudioState.completed) {
      emoji = "🤗"; // Happy/Idle after reading
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey<String>(emoji),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
