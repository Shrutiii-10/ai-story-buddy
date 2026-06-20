import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import '../providers/quiz_provider.dart';
import 'option_button.dart';

class QuizCard extends ConsumerStatefulWidget {
  const QuizCard({super.key});

  @override
  ConsumerState<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends ConsumerState<QuizCard> {
  late ConfettiController _confettiController;
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAnswer(String answer) {
    final quizState = ref.read(quizProvider);
    if (quizState.status == QuizStatus.correctAnswer) return;

    setState(() {
      _selectedAnswer = answer;
    });

    ref.read(quizProvider.notifier).submitAnswer(answer);
    final isCorrect = answer == quizState.quiz.answer;

    if (isCorrect) {
      _confettiController.play();
    } else {
      HapticFeedback.vibrate();
      _shakeKey.currentState?.shake();
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final quiz = quizState.quiz;
    final isCorrectState = quizState.status == QuizStatus.correctAnswer;
    final isWrongState = quizState.status == QuizStatus.wrongAnswer;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FadeInUp(
          child: ShakeWidget(
            key: _shakeKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    quiz.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...quiz.options.map((option) {
                    final isSelected = _selectedAnswer == option;
                    return OptionButton(
                      text: option,
                      isSelected: isSelected,
                      isCorrect: isSelected && isCorrectState,
                      isWrong: isSelected && isWrongState,
                      disabled: isCorrectState,
                      onTap: () => _handleAnswer(option),
                    );
                  }),
                  if (isCorrectState)
                    ZoomIn(
                      child: Semantics(
                        label: "Success Message",
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            "🎉 Amazing!\nYou found Pip's blue gear!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isWrongState && !isCorrectState)
                    FadeIn(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Almost! Try again!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
        ),
      ],
    );
  }
}

// Custom Shake Widget
class ShakeWidget extends StatefulWidget {
  final Widget child;

  const ShakeWidget({super.key, required this.child});

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
        }
      });
  }

  void shake() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // A simple sine wave to shake back and forth
        final offset = sin(_controller.value * pi * 4) * 8;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
