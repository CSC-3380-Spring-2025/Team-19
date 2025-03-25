import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    currentWordLadder = hideWords(wordList);
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
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Congratulations!"),
              content: Text("You completed the Word Ladder! Score: $score"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    resetGame();
                  },
                  child: Text("Play Again"),
                )
              ],
            ),
          );
        }
      } else {
        setState(() {
          incorrectGuesses++;
          score -= 100;
        });
      }
    }
  }

  void resetGame() {
    setState(() {
      currentIndex = 1;
      incorrectGuesses = 0;
      score = 10000;
      currentWordLadder = hideWords(wordList);
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
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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