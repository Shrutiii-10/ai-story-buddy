import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_model.dart';

enum QuizStatus { hidden, revealed, wrongAnswer, correctAnswer }

class QuizState {
  final QuizStatus status;
  final QuizModel quiz;

  QuizState({required this.status, required this.quiz});

  QuizState copyWith({QuizStatus? status, QuizModel? quiz}) {
    return QuizState(
      status: status ?? this.status,
      quiz: quiz ?? this.quiz,
    );
  }
}

class QuizNotifier extends Notifier<QuizState> {
  @override
  QuizState build() {
    final Map<String, dynamic> quizJson = {
      "question": "What colour was Pip the Robot's lost gear?",
      "options": ["Red", "Green", "Blue", "Yellow"],
      "answer": "Blue"
    };
    
    final quizModel = QuizModel.fromJson(quizJson);
    return QuizState(status: QuizStatus.hidden, quiz: quizModel);
  }

  void revealQuiz() {
    state = state.copyWith(status: QuizStatus.revealed);
  }

  void submitAnswer(String selectedAnswer) {
    if (selectedAnswer == state.quiz.answer) {
      state = state.copyWith(status: QuizStatus.correctAnswer);
    } else {
      state = state.copyWith(status: QuizStatus.wrongAnswer);
    }
  }
  
  void resetQuiz() {
    state = state.copyWith(status: QuizStatus.hidden);
  }
}

final quizProvider = NotifierProvider<QuizNotifier, QuizState>(() {
  return QuizNotifier();
});
