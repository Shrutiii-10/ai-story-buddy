# AI Story Buddy

AI Story Buddy is a delightful, kid-friendly Flutter application that combines storytelling, text-to-speech narration, and a data-driven interactive quiz. It features polished animations, haptic feedback, and a highly responsive state-driven UI.

## Features

* **Story narration**: Uses `flutter_tts` to read a compelling story aloud.
* **Data-driven quiz**: Dynamic questions, options, and validation loaded from models.
* **Confetti celebration**: Highly engaging positive feedback for correct answers using `confetti`.
* **Error handling**: Robust state management handles TTS loading delays, initialization issues, and empty text securely.
* **Riverpod state management**: Clean architectural separation of logic, state, and UI.
* **Animations**: Utilizes `animate_do` and `AnimatedSwitcher` for smooth, polished reveals (slide-up, fades, and scaling).
* **Accessibility**: Includes Semantics and accessible contrast for broad usability.

## Framework Choice

Flutter was chosen as the framework for this application for several reasons:
* **Single codebase for multiple platforms**: Enables seamless deployment to iOS, Android, and Web without writing platform-specific code.
* **Smooth 60 FPS animations**: The built-in animation framework effortlessly handles UI transitions like `AnimatedSwitcher`, shake animations, and confetti bursts.
* **Strong Riverpod state management support**: Flutter's declarative UI pairs perfectly with Riverpod, allowing for a robust, unidirectional, and highly testable state flow.
* **Easy flutter_tts integration**: Native plugins allow for quick integration of system-level text-to-speech engines.
* **Fast and flexible UI development**: Hot reload and a vast library of customizable widgets make it easy to craft a highly polished, kid-friendly interface quickly.

## Architecture

* **Models** (`lib/models`): Define structured data schemas like `QuizModel`.
* **Providers** (`lib/providers`): Manage logic and global state via Riverpod (`audio_provider` and `quiz_provider`). Ensure reactive UI updates based strictly on state changes.
* **Services** (`lib/services`): Isolate side effects and device integrations, such as `tts_service` handling the `flutter_tts` engine.
* **Widgets** (`lib/widgets`): Modular UI components (`AiBuddy`, `StoryCard`, `QuizCard`, `OptionButton`, `LoadingOverlay`) that subscribe to providers for changes.

## State Flow

The application follows a strict unidirectional data flow:
1. **Idle**: App launches. AI Buddy is smiling. "Read Me a Story" is available.
2. **Preparing**: User taps button. Loading overlay displays ("🤖 Buddy is getting ready...").
3. **Playing**: Narration begins. AI Buddy animated state changes to reading. Button is disabled ("Reading Story...").
4. **Completed**: Narration finishes. The story view smoothly slides out.
5. **Quiz**: Quiz view slides and fades in. User selects an option.
6. **Success/Error**: 
   - Incorrect: Haptic feedback, shake animation, sad Buddy, error message.
   - Correct: Confetti bursts, success message scales in, options disabled, happy Buddy.

## Running Instructions

To run this project, make sure you have the Flutter SDK installed and properly configured.

```bash
flutter pub get
flutter run
```

## Assumptions

* **Quiz backend**: The quiz questions, options, and answers are simulated as JSON payloads locally to represent a typical remote backend response.
* **Text-to-Speech Engine**: The application relies on the system's native TTS engine. A network connection may be required depending on the device's default TTS configuration (e.g., Google TTS on Android or SpeechSynthesis on Chrome).

## Caching Approach

* The current implementation uses the device's native TTS engine through `flutter_tts` and does not require remote audio caching.
* If a remote provider such as ElevenLabs were used, audio would be cached locally using the story text as a cache key.
* Cached audio would be reused to reduce latency and network usage.

## AI Usage & Engineering Judgment

* AI assistance was used for architecture suggestions, state management guidance, UI refinement, and error-handling review.
* One AI suggestion that was rejected was hardcoding quiz options directly in the UI because the assignment required a truly data-driven quiz renderer.
* One issue encountered during development was that the quiz initially appeared immediately when the application launched.
* The issue was resolved by introducing audio state management and revealing the quiz only after narration completion callbacks.
