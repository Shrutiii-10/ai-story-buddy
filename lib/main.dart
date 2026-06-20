import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: AiStoryBuddyApp()));
}

class AiStoryBuddyApp extends StatelessWidget {
  const AiStoryBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Story Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          surface: Colors.yellow.shade50,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.fredokaTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
