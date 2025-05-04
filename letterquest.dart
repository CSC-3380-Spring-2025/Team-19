import 'package:flutter/material.dart';
import 'package:team_19/models/user_model.dart';
import 'dart:async';
import 'keyboard_ui.dart';
import 'package:team_19/db/databasehelper.dart';
import 'package:team_19/models/letterquest_model.dart';

class LetterQuestGame extends StatefulWidget {
  final String userName;
  const LetterQuestGame({super.key, required this.userName});
  @override
  _LetterQuestGameState createState() => _LetterQuestGameState();
}

class _LetterQuestGameState extends State<LetterQuestGame> {
  final TextEditingController _phraseController = TextEditingController();
  String phrase = "";
  String hint = "";
  Set<String> guessedLetters = {};
  bool isSolvingPhrase = false;
  String fullPhraseAttempt = "";
  int incorrectAttempts = 0;
  bool isGameOver = false;
  bool showSubmitButton = true;


  late Timer _timer;
  int secondsElapsed = 0;

  int _currentLevelId = 1;

  late ElevatedButton submitButton;

  @override
  void initState() {
    super.initState();
    _loadLevel();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _phraseController.dispose(); 
    super.dispose();
  }

  Future<void> _loadLevel() async {
    try {
    final Letterquest? level = await DatabaseHelper.fetchLetterquestById(_currentLevelId);

    if (level != null) {
      setState(() {
        phrase = level.phrase.toUpperCase(); // Force uppercase
        hint = level.hint;
        _currentLevelId++; // Move to next level for next time
      });
    } else {
      setState(() {
        phrase = '';
        hint = 'No more puzzles available.';
      });
    }
  } catch (e) {
    setState(() {
      phrase = '';
      hint = 'Error loading puzzle.';
    });
    print('Error loading Letterquest level: $e');
  }
  }

  Future<void> _loadNextLevel() async {
    setState(() {
      isGameOver = false; 
      phrase = "";
      hint = "";
      guessedLetters = {};
      isSolvingPhrase = false;
      fullPhraseAttempt = "";
      incorrectAttempts = 0;
      secondsElapsed = 0; 
      showSubmitButton = true;
      _startTimer();     
    });
    await _loadLevel();        
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

  final TextStyle appBarTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: appBarTitleStyle,
        title: Text("Letter Quest"),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Center(
                  child: Text(
                    "⏱️ $secondsElapsed s",
                    style: appBarTitleStyle,
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
                barrierDismissible: false,
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
      body: phrase.isEmpty
      ? Center(child: CircularProgressIndicator())
      : Column(
        children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/letterquest_logo.png',
            height: 200,
          ),
          _buildPhraseDisplay(),
          SizedBox(height: 20),
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
          if (isGameOver)
            ElevatedButton(
              onPressed: _loadNextLevel,
              child: Text('Next Level'),
            )
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
            autofocus: true,
            onChanged: (value) => fullPhraseAttempt = value.toUpperCase(),
            onSubmitted: (_) => _submitPhraseGuess(), // Handle Enter key
            decoration: InputDecoration(
              labelText: "Enter full phrase",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          if (showSubmitButton)
            submitButton = ElevatedButton(
              onPressed: () {
                bool isCorrect = fullPhraseAttempt == phrase;
                if (isCorrect) {
                  _showWinPopup();
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
              child: Text("Submit Guess"),
            )
          else
            SizedBox.shrink()

        ],
      ),
    );
  }

  void _submitPhraseGuess() {
    fullPhraseAttempt = _phraseController.text.toUpperCase(); // <-- Added
    bool isCorrect = fullPhraseAttempt == phrase;
    if (isCorrect) {
      _showWinPopup();
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

  void _showWinPopup() async
  {
    _timer.cancel();
    setState(() {
      isGameOver = true;
      showSubmitButton = false;
    });


    User? winner = await DatabaseHelper.fetchUserByName(widget.userName);

    if (winner != null) {
      int actualID = _currentLevelId - 1;

      Map<int, int> winnerTimes = winner.letterquestTimes;
      
      if(winnerTimes[actualID] != null)
      {
        if(winnerTimes[actualID]! > secondsElapsed)
        {
          winnerTimes[actualID] = secondsElapsed;
          winner.letterquestTimes = winnerTimes;
        }
      }
      else
      {
        winnerTimes[actualID] = secondsElapsed;
        winner.letterquestTimes = winnerTimes;
      }
      

      Map<int, int> winnerScores = winner.letterquestScores;
      winnerScores[actualID] = 0;
      winner.letterquestScores = winnerScores;

      await DatabaseHelper.updateUser(winner);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text("🎉 You got it!"),
        content: Text("Congratulations! You solved it in $secondsElapsed seconds."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/letterquestleaderboard'); //Navigate to Leaderboard
            },
            child: const Text('View Leaderboard'),
          ),
        ],
      ),
    );
  }
}
