import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_provider.dart';

class LoadingOverlay extends ConsumerWidget {
  final Widget child;
  const LoadingOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);

    return Stack(
      children: [
        child,
        if (audioState == AudioState.preparing)
          Container(
            color: Colors.white.withValues(alpha: 0.8),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                ),
                const SizedBox(height: 24),
                const Text(
                  "🤖 Buddy is getting ready to tell your story...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
