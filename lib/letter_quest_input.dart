import 'package:flutter/material.dart';
import 'dart:async';
import 'keyboard_ui.dart';

class LetterQuestGame extends StatefulWidget {
  @override
  _LetterQuestGameState createState() => _LetterQuestGameState();
}

class _LetterQuestGameState extends State<LetterQuestGame> {
  final LetterQuestGameLogic gameLogic = LetterQuestGameLogic();
  late Timer _timer;
  int secondsElapsed = 0;
  bool isSolvingPhrase = false;
  String fullPhraseAttempt = "";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsElapsed < 999) {
        setState(() {
          secondsElapsed++;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void handleGuess(String guess) {
    setState(() {
      gameLogic.onGuess(guess);
      if (gameLogic.isGameOver) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('🎉 You Won!'),
            content: Text('You solved the puzzle in $secondsElapsed seconds!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter Quest Game'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                "${secondsElapsed}s",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  title: Text('How to Play LetterQuest'),
                  content: Text(
                    "Welcome to LetterQuest!\n\n"
                    "You will be given a blank sentence with missing letters.\n\n"
                    "A category hint will help you narrow down the answer.\n\n"
                    "You have two options on your turn:\n\n"
                    "1. Guess a letter - If the letter is in the sentence, it will be revealed.\n\n"
                    "2. Guess the full sentence - If correct, you win!\n\n"
                    "Your score starts at a base value and decreases with each guessed letter and incorrect sentence attempt.\n\n"
                    "Once the puzzle is solved, your score will also take time into account.\n\n"
                    "Try to solve the puzzle with the fewest guesses and as quickly as possible!",
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/letterquest_logo.png',
            height: 200,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LetterQuestPhraseDisplay(
                    phrase: gameLogic.phrase,
                    hint: gameLogic.hint,
                    guessedLetters: gameLogic.guessedLetters,
                  ),
                  SizedBox(height: 20),
                  gameLogic.isGameOver
                      ? Text("You got it!",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                      : Text("Incorrect Attempts: ${gameLogic.incorrectAttempts}",
                          style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          if (!isSolvingPhrase) ...[
            ElevatedButton(
              onPressed: () => setState(() {
                isSolvingPhrase = true;
                fullPhraseAttempt = "";
              }),
              child: Text("Solve the Puzzle"),
            ),
          ],
          if (isSolvingPhrase) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) => fullPhraseAttempt = value.toUpperCase(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter your full phrase guess",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      bool correct = fullPhraseAttempt == gameLogic.phrase;
                      if (correct) {
                        setState(() {
                          gameLogic.onGuess(fullPhraseAttempt);
                          isSolvingPhrase = false;
                        });
                      } else {
                        setState(() {
                          isSolvingPhrase = false;
                          fullPhraseAttempt = "";
                          gameLogic.incorrectAttempts++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Incorrect phrase guess. Try again.")),
                        );
                      }
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ] else ...[
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: WordLadderKeyboard(
                  guessedLetters: gameLogic.guessedLetters,
                  phrase: gameLogic.phrase,
                  onEnter: () {},
                  onDelete: () {},
                  onKeyPress: (key) {
                    setState(() {
                      gameLogic.onGuess(key);
                    });
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class LetterQuestPhraseDisplay extends StatelessWidget {
  final String phrase;
  final String hint;
  final Set<String> guessedLetters;

  const LetterQuestPhraseDisplay({
    super.key,
    required this.phrase,
    required this.hint,
    required this.guessedLetters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: phrase.split('').map((char) {
            return char == ' '
                ? SizedBox(width: 16.0)
                : Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2.0)),
                    ),
                    child: Text(
                      guessedLetters.contains(char.toUpperCase()) ? char : '_',
                      style: TextStyle(
                        fontSize: _calculateFontSize(context, phrase.length),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
          }).toList(),
        ),
        SizedBox(height: 20.0),
        Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            hint,
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  double _calculateFontSize(BuildContext context, int length) {
    double baseSize = 24.0;
    return (length > 15) ? baseSize - (length - 15) * 0.5 : baseSize;
  }
}

class LetterQuestGameLogic {
  final String phrase = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG";
  final String hint = "PANGRAM";
  Set<String> guessedLetters = {};
  int incorrectAttempts = 0;
  bool isGameOver = false;

  List<String> get displayPhrase {
    return phrase.split('').map((char) {
      if (char == ' ' || char == "'") {
        return char;
      }
      return guessedLetters.contains(char.toUpperCase()) ? char : '_';
    }).toList();
  }

  void onGuess(String guess) {
    if (isGameOver) return;
    if (guess.length == 1) {
      if (!guessedLetters.contains(guess.toUpperCase())) {
        guessedLetters.add(guess.toUpperCase());
        if (!phrase.contains(guess.toUpperCase())) {
          incorrectAttempts++;
        }
      }
    } else {
      if (guess.toUpperCase() == phrase) {
        isGameOver = true;
      } else {
        incorrectAttempts++;
      }
    }
  }
}