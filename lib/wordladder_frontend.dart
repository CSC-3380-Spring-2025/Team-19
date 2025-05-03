import 'package:flutter/material.dart';
import 'dart:async';
import 'package:team_19/db/databasehelper.dart';
import 'package:team_19/models/user_model.dart';
import 'package:team_19/models/wordladder_model.dart';

class WordLadderGame extends StatefulWidget {
  final String userName;
  const WordLadderGame({super.key, required this.userName});
  @override
  _WordLadderGameApp createState() => _WordLadderGameApp();
}

class _WordLadderGameApp extends State<WordLadderGame> {
  //final List<String> wordList = ['BASKET', 'BALL', 'GAME', 'SHOW', 'CASE'];
  List<String> wordList = [""];
  late List<String> currentWordLadder;
  int score = 10000;
  int incorrectGuesses = 0;
  int currentIndex = 1;
  TextEditingController wordController = TextEditingController();
  bool isGameOver = false;

  // Timer-related
  late Timer _timer;
  int secondsElapsed = 0;

  int _currentLevelId = 1;

  @override
  void initState() {
    super.initState();
    currentWordLadder = hideWords(wordList);
    _loadLevel();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadLevel() async {
    try {
    final Wordladder? level = await DatabaseHelper.fetchWordladderById(_currentLevelId);

    if (level != null) {
      setState(() {
        wordList = level.wordList; 
        currentWordLadder = hideWords(wordList); 
        _currentLevelId++; // Move to next level for next time
      });
    } else {
      setState(() {
        wordList = [""];
        currentWordLadder = [""];
      });
    }
  } catch (e) {
    setState(() {
      wordList = [""];
      currentWordLadder = [""];
    });
    print('Error loading Wordladder level: $e');
  }
  }

  Future<void> _loadNextLevel() async {
    setState(() {
      isGameOver = false; 
      score = 10000;
      incorrectGuesses = 0;
      currentIndex = 1;
      secondsElapsed = 0; 
    });
    await _loadLevel(); 
    _startTimer();       
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
          _showWinPopup();
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
        title: Text("Word Ladder"),
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
                "⏱️ $secondsElapsed s",
                style: appBarTitleStyle,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            tooltip: 'How to Play',
            onPressed: () {
              _timer.cancel();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Text('How to Play Word Ladder'),
                  content: Text(
                    "Welcome to Word Ladder!\n\n"
                    "🖇️ You will be given a starting word and a hint for the next word, which begins with the first letter provided.\n\n"
                    "⛓️ Each word connects to the next in a meaningful way, forming a continuous chain.\n\n"
                    "💡 For example: 'Dog' → 'F___' (where the answer could be 'food').\n\n"
                    "🌟 Your goal is to correctly complete the sequence as efficiently as possible.\n\n"
                    "🤨💭 Think of words that logically follow the previous one and match the given hint!",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startTimer();
                      }, 
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: wordList.isEmpty
      ? Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.asset(
            'assets/images/wordladder_logo.png',
            height: 200,
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
            TextField(
              controller: wordController,
              onSubmitted: (_) => checkGuess(),
              decoration: InputDecoration(labelText: "Enter your guess"),
            ),
            SizedBox(height: 10), 
            ElevatedButton(onPressed: checkGuess, child: Text("Submit Guess")),
            SizedBox(height: 10),
            Text("Incorrect Guesses: $incorrectGuesses"),
            if (isGameOver)
              ElevatedButton(
                onPressed: _loadNextLevel,
                child: Text('Next Level'),
              )
          ],
        ),
      ),
    );
  }

  void _showWinPopup() async
  {
    _timer.cancel();
    setState(() {
      isGameOver = true;
    });


    User? winner = await DatabaseHelper.fetchUserByName(widget.userName);

    if (winner != null) {
      int actualID = _currentLevelId - 1;

      bool savedNew = false;

      Map<int, int> winnerScores = winner.wordladderScores;
      
      if(winnerScores[actualID] != null)
      {
        if(winnerScores[actualID]! < score)
        {
          winnerScores[actualID] = score;
          winner.wordladderScores = winnerScores;

          savedNew = true;
        }
      }
      else
      {
        winnerScores[actualID] = score;
        winner.wordladderScores = winnerScores;

        savedNew = true;
      }

      if(savedNew)
      {
        Map<int, int> winnerTimes = winner.wordladderTimes;
        
        if(winnerTimes[actualID] != null)
        {
          if(winnerTimes[actualID]! > secondsElapsed)
          {
            winnerTimes[actualID] = secondsElapsed;
            winner.wordladderTimes = winnerTimes;
          }
        }
        else
        {
          winnerTimes[actualID] = secondsElapsed;
          winner.wordladderTimes = winnerTimes;
        }
      }


      await DatabaseHelper.updateUser(winner);
    }


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Congratulations!"),
        content: Text("You completed the Word Ladder!\n\nScore: $score\nTime: ${secondsElapsed}s"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //resetGame();
            },
            child: Text("OK"),
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
}