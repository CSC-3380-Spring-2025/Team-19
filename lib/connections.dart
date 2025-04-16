import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const ConnectionsGameScreen());
}


class ConnectionsGameScreen extends StatefulWidget {
  const ConnectionsGameScreen({super.key});

  @override
  _ConnectionsGameScreenState createState() => _ConnectionsGameScreenState();
}

class _ConnectionsGameScreenState extends State<ConnectionsGameScreen> {
  Map<String, List<String>> categories = {
    "Colors": ["Red", "Blue", "Green", "Yellow"],
    "Fruits": ["Apple", "Banana", "Grape", "Orange"],
    "Animals": ["Dog", "Cat", "Horse", "Elephant"],
    "Instruments": ["Guitar", "Piano", "Violin", "Drums"]
  };

  late List<String> words;
  List<String> selectedWords = [];
  Set<String> foundCategories = {};
  int attemptsLeft = 4;

  // Timer variables
  Timer? _gameTimer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    words = categories.values.expand((e) => e).toList();
    words.shuffle(Random());
    _startTimer(); // Start the timer when the game begins
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedSeconds < 999) {
        setState(() {
          elapsedSeconds++;
        });
      } else {
        _gameTimer?.cancel(); // Stop when reaching the cap
      }
    });
  }

  void toggleSelection(String word) {
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else if (selectedWords.length < 4) {
        selectedWords.add(word);
      }
    });
  }

  void showWinPopup(int attempts) {
    int attemptsTaken = 4 - attempts;
    int score = 10000 - (attemptsTaken * 2500) - (elapsedSeconds * 10); // Score calculator for popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: Text('You found all categories!\nFinal Score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/connectionsleaderboard'); //Navigate to Leaderboard
            },
            child: const Text('View Leaderboard'),
          ),
        ],
      ),
    );
  }

  void checkSelection() {
    if (selectedWords.length == 4) {
      bool isCorrect = false;
      bool oneAway = false;

      for (var category in categories.values) {
        Set<String> correctSet = category.toSet();
        Set<String> selectionSet = selectedWords.toSet();

        if (selectionSet.containsAll(correctSet) &&
            correctSet.containsAll(selectionSet)) {
          isCorrect = true;
          foundCategories.add(category.toString());
          words.removeWhere((word) => selectionSet.contains(word));
          break;
        } else if (selectionSet.intersection(correctSet).length == 3) {
          oneAway = true;
        }
      }

      setState(() {
        if (isCorrect) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Correct! You've found a category.")),
          );
        } else {
          if (oneAway) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("One away! Try again.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Incorrect. Try again.")),
            );
          }
          attemptsLeft--;
        }
        selectedWords.clear();

        if (foundCategories.length == categories.length) {
          _gameTimer?.cancel(); // Stop the timer when game is won
          showWinPopup(attemptsLeft);
        }

        if (attemptsLeft == 0) {
          _gameTimer?.cancel(); // Stop the timer when out of attempts
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Game Over! No attempts left.")),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Connections"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                "⏱️ $elapsedSeconds s", // Timer display
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'How to Play',
            onPressed: () {
              _gameTimer?.cancel();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('How to Play Connections'),
                  content: const Text(
                    "Welcome to Connections!\n\n"
                    "You will be given a set of 16 words.\n\n"
                    "Your goal is to find four groups of four words that share a common theme.\n\n"
                    "Select four words that you think belong together and submit your guess.\n\n"
                    "If correct, the words will be grouped together. If incorrect, you will receive a 'one away' hint if only one word is incorrect.\n\n"
                    "You have a total of four incorrect attempts before the game ends.\n\n"
                    "Think critically about the relationships between words and find all the correct groups!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startTimer();
                      }, 
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Image.asset(
            '../assets/images/connections_logo.png',
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(
            "Attempts Left: $attemptsLeft",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // Set a fixed height to fit all the words
          Expanded(
            // This ensures the words grid takes up available space
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // Disable scrolling (for better size control, the user shouldn't need to scroll)
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  String word = words[index];
                  bool isSelected = selectedWords.contains(word);
                  return GestureDetector(
                    onTap: () => toggleSelection(word),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5), // Space before the submit button
          SizedBox(
            width: 200,
            height: 75,
            child: ElevatedButton(
              onPressed: (selectedWords.length == 4 && attemptsLeft > 0)
                  ? checkSelection
                  : null,
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
