import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';

import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/ai_buddy.dart';
import '../widgets/story_card.dart';
import '../widgets/quiz_card.dart';
import '../widgets/loading_overlay.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final quizState = ref.watch(quizProvider);

    final String storyText = "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

    // Automatically reveal quiz after reading finishes
    ref.listen<AudioState>(audioProvider, (previous, next) {
      if (next == AudioState.completed) {
        ref.read(quizProvider.notifier).revealQuiz();
      }
    });

    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      body: LoadingOverlay(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Semantics(
                  label: "AI Buddy Avatar",
                  child: const AiBuddy(),
                ),
                const SizedBox(height: 32),
                
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    switchInCurve: Curves.easeOutCubic,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(0.0, 0.2),
                        end: Offset.zero,
                      ).animate(animation);
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: slideAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: quizState.status == QuizStatus.hidden
                        ? Column(
                            key: const ValueKey('story_view'),
                            children: [
                              FadeIn(
                                child: Semantics(
                                  label: "Story Card",
                                  child: StoryCard(text: storyText),
                                ),
                              ),
                              const Spacer(),
                              if (audioState == AudioState.error) ...[
                                const Text(
                                  "Oops! Buddy couldn't read the story.\nPlease try again.",
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                              ],
                              Semantics(
                                button: true,
                                label: "Read Me a Story Button",
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 60,
                                  child: ElevatedButton(
                                    onPressed: (audioState == AudioState.playing || audioState == AudioState.preparing)
                                        ? null
                                        : () {
                                            ref.read(audioProvider.notifier).readStory(storyText);
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade400,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: Text(
                                      audioState == AudioState.error 
                                          ? "Retry" 
                                          : audioState == AudioState.preparing
                                              ? "Getting Ready..."
                                              : audioState == AudioState.playing
                                                  ? "Reading Story..."
                                                  : "Read Me a Story",
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SingleChildScrollView(
                            key: ValueKey('quiz_view'),
                            physics: BouncingScrollPhysics(),
                            child: QuizCard()
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
