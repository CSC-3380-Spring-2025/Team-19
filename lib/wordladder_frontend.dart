import 'package:flutter/material.dart';
import 'dart:async';

class WordLadderGame extends StatefulWidget {
  @override
  _WordLadderGameApp createState() => _WordLadderGameApp();
}

class _WordLadderGameApp extends State<WordLadderGame> {
  final List<String> wordList = ['BASKET', 'BALL', 'GAME', 'SHOW', 'CASE'];
  late List<String> currentWordLadder;
  int score = 10000;
  int incorrectGuesses = 0;
  int currentIndex = 1;
  TextEditingController wordController = TextEditingController();

  // Timer-related
  late Timer _timer;
  int secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    currentWordLadder = hideWords(wordList);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsElapsed < 999) {
        setState(() {
          secondsElapsed++;
          if (score > 0) {
            score = (score - 10).clamp(0, 10000);
          }
        });
      } else {
        _timer.cancel();
      }
    });
  }

  List<String> hideWords(List<String> words) {
    List<String> newList = List.from(words);
    for (int i = 1; i < words.length - 1; i++) {
      newList[i] = words[i][0] + " _ " * (words[i].length - 1);
    }
    return newList;
  }

  void checkGuess() {
    String userInput = wordController.text.trim().toUpperCase();
    if (userInput.length == wordList[currentIndex].length) {
      if (userInput == wordList[currentIndex].toUpperCase()) {
        setState(() {
          currentWordLadder[currentIndex] = wordList[currentIndex];
          currentIndex++;
          wordController.clear();
        });

        if (currentIndex >= wordList.length - 1) {
          _timer.cancel();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Congratulations!"),
              content: Text("You completed the Word Ladder!\n\nScore: $score\nTime: ${secondsElapsed}s"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                  child: Text("Play Again"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/wordladderleaderboard'); //Navigate to leaderboard
                  },
                  child: const Text('View Leaderboard'),
                ),
              ],
            ),
          );
        }
      } else {
        setState(() {
          incorrectGuesses++;
          score = (score - 100).clamp(0, 10000);
        });
      }
    }
  }

  void resetGame() {
    setState(() {
      currentIndex = 1;
      incorrectGuesses = 0;
      score = 10000;
      secondsElapsed = 0;
      currentWordLadder = hideWords(wordList);
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Word Ladder Game"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "${secondsElapsed}s",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: 'How to Play',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('How to Play Word Ladder'),
                  content: Text(
                    "Welcome to Word Ladder!\n\n"
                    "You will be given a starting word and a hint for the next word, which begins with the first letter provided.\n\n"
                    "Each word connects to the next in a meaningful way, forming a continuous chain.\n\n"
                    "For example: 'dog' → 'F___' (where the answer could be 'food').\n\n"
                    "Your goal is to correctly complete the sequence as efficiently as possible.\n\n"
                    "Think of words that logically follow the previous one and match the given hint!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
          Image.asset(
            '../assets/images/wordladder_logo.png',
            height: 300,
          ),
            Text(
              "Word Ladder Progress:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: currentWordLadder
                  .map((word) => Text(word, style: TextStyle(fontSize: 24)))
                  .toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: wordController,
              onSubmitted: (_) => checkGuess(),
              decoration: InputDecoration(labelText: "Enter your guess"),
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: checkGuess, child: Text("Submit Guess")),
            SizedBox(height: 20),
            Text("Incorrect Guesses: $incorrectGuesses"),
            Text("Score: $score"),
          ],
        ),
      ),
    );
  }
}
