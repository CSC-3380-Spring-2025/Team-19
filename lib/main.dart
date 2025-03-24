import 'package:flutter/material.dart';
import 'game_selector.dart'; // Import the game selection screen
import 'connections.dart';
import 'letterquest.dart';
import 'wordladder_frontend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WordStorm Games',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameSelectionScreen(), // ✅ Start with the Game Selection screen
      routes: {
        '/connections': (context) => ConnectionsGameApp(),
        '/letterquest': (context) => LetterQuestGame(),
        '/wordladder': (context) => WordLadderGame(),
      },
    );
  }
}
