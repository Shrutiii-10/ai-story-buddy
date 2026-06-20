import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/tts_service.dart';

enum AudioState { idle, preparing, playing, completed, error }

class AudioNotifier extends Notifier<AudioState> {
  @override
  AudioState build() {
    final ttsService = ref.watch(ttsServiceProvider);
    ttsService.setStartHandler(() {
      state = AudioState.playing;
    });

    ttsService.setCompletionHandler(() {
      if (state == AudioState.playing || state == AudioState.preparing) {
        state = AudioState.completed;
      }
    });

    ttsService.setErrorHandler((msg) {
      if (state == AudioState.playing || state == AudioState.preparing) {
        state = AudioState.error;
      }
    });
    
    return AudioState.idle;
  }

  Future<void> readStory(String text) async {
    if (text.trim().isEmpty) {
      state = AudioState.error;
      return;
    }

    state = AudioState.preparing;
    
    try {
      final ttsService = ref.read(ttsServiceProvider);
      // Simulating a small delay to allow the UI to show the 'preparing' state
      await Future.delayed(const Duration(milliseconds: 500));
      await ttsService.speak(text);
    } catch (e) {
      state = AudioState.error;
    }
  }

  void reset() {
    state = AudioState.idle;
  }
}

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

final audioProvider = NotifierProvider<AudioNotifier, AudioState>(() {
  return AudioNotifier();
});
