import 'package:flutter/material.dart';
import 'keyboard_ui.dart'; // your onscreen keyboard widget

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Letter Quest Game"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(
            '',
            height: 200,
          ),
          _buildPhraseDisplay(),
          Text(hint),
          SizedBox(height: 10),
          Text("Incorrect Attempts: $incorrectAttempts"),
          SizedBox(height: 20),
          if (!isSolvingPhrase) _buildSolveButton(),
          if (isSolvingPhrase) _buildPhraseGuessInput(),
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
            onPressed: _submitPhraseGuess,
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

  @override
  void dispose() {
    _phraseController.dispose(); 
    super.dispose();
  }
}
