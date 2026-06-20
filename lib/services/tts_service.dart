import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.4); // Kid friendly speed
    _flutterTts.setPitch(1.2); // slightly higher pitch
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void setStartHandler(Function() handler) {
    _flutterTts.setStartHandler(handler);
  }

  void setCompletionHandler(Function() handler) {
    _flutterTts.setCompletionHandler(handler);
  }

  void setErrorHandler(Function(dynamic) handler) {
    _flutterTts.setErrorHandler(handler);
  }
}
