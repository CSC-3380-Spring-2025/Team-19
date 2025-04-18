import 'package:flutter/material.dart';
import 'dart:async';
import 'keyboard_ui.dart';

class LetterQuestGame extends StatefulWidget {
  @override
  _LetterQuestGameState createState() => _LetterQuestGameState();
}

class _LetterQuestGameState extends State<LetterQuestGame> {
  final TextEditingController _phraseController = TextEditingController();
  final String phrase = "THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG";
  final String hint = "PANGRAM";
  Set<String> guessedLetters = {};
  bool isSolvingPhrase = false;
  String fullPhraseAttempt = "";
  int incorrectAttempts = 0;
  bool isGameOver = false;

  late Timer _timer;
  int secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _phraseController.dispose(); 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Letter Quest"),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Center(
                  child: Text(
                    "⏱️ $secondsElapsed s",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: 'How to Play',
            onPressed: () {
              _timer.cancel();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("How to Play Letter Quest"),
                  content: Text(
                    "Welcome to Letter Quest!\n\n"
                    "🧩 You'll see a blank phrase, and your job is to guess the letters in it.\n\n"
                    "💡 A hint is provided to help you guess the phrase.\n\n"
                    "🎯 You can:\n"
                    " - Click letters on the keyboard to guess them one at a time.\n"
                    " - Click 'Solve the Puzzle' to guess the full phrase.\n\n"
                    "⚠️ Incorrect guesses will be tracked, and you’ll be timed!\n\n"
                    "⏱ Try to solve the phrase with the fewest mistakes and in the shortest time!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startTimer();
                      },
                      child: Text("Got it!"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/letterquest_logo.png',
            height: 200,
          ),
          _buildPhraseDisplay(),
          Text(hint, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Text("Incorrect Attempts: $incorrectAttempts"),
          SizedBox(height: 20),
          if (!isSolvingPhrase) _buildSolveButton(),
          if (isSolvingPhrase) _buildPhraseGuessInput(),
          SizedBox(height: 20),
          if (!isSolvingPhrase && !isGameOver)
            WordLadderKeyboard(
              guessedLetters: guessedLetters,
              phrase: phrase,
              onKeyPress: _handleLetterGuess,
              onEnter: () {},
              onDelete: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildPhraseDisplay() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4.0,
      runSpacing: 8.0,
      children: phrase.split('').map((char) {
        if (char == ' ') return SizedBox(width: 16);
        bool isGuessed = guessedLetters.contains(char.toUpperCase());
        return Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 2.0)),
          ),
          child: Text(
            isGuessed ? char : "_",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSolveButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isSolvingPhrase = true;
          fullPhraseAttempt = "";
          _phraseController.clear();
        });
      },
      child: Text("Solve the Puzzle"),
    );
  }

  Widget _buildPhraseGuessInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            controller: _phraseController,
            onChanged: (value) => fullPhraseAttempt = value.toUpperCase(),
            onSubmitted: (_) => _submitPhraseGuess(), // Handle Enter key
            decoration: InputDecoration(
              labelText: "Enter full phrase",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              bool isCorrect = fullPhraseAttempt == phrase;
              if (isCorrect) {
                _timer.cancel();
                setState(() {
                  isGameOver = true;
                });
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("🎉 You got it!"),
                    content: Text("Congratulations! You solved it in $secondsElapsed seconds."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  incorrectAttempts++;
                  isSolvingPhrase = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Incorrect guess. Try again!")),
                );
              }
            },
            // onPressed: _submitPhraseGuess,
            child: Text("Submit Guess"),
          ),
        ],
      ),
    );
  }

  void _submitPhraseGuess() {
    fullPhraseAttempt = _phraseController.text.toUpperCase(); // <-- Added
    bool isCorrect = fullPhraseAttempt == phrase;
    if (isCorrect) {
      _timer.cancel();
      setState(() {
        isGameOver = true;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("🎉 You got it!"),
          content: Text("Congratulations! You solved it."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        incorrectAttempts++;
        isSolvingPhrase = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect guess. Try again!")),
      );
    }
  }

  void _handleLetterGuess(String letter) {
    setState(() {
      guessedLetters.add(letter);
      if (!phrase.contains(letter)) {
        incorrectAttempts++;
      }
    });
  }
}
