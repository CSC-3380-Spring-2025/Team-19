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
  List<String> wordList = [""];
  late List<String> currentWordLadder;
  int score = 10000;
  int incorrectGuesses = 0;
  int currentIndex = 1;
  TextEditingController wordController = TextEditingController();

  // Timer-related
  late Timer _timer;
  int secondsElapsed = 0;

  int _currentLevelId = 1;

  bool hasSelectedLevel = false;

  @override
  void initState() {
    super.initState();
    currentWordLadder = hideWords(wordList);
    _showLevelSelector();
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
            icon: Icon(Icons.grid_view),
            tooltip: 'Select Level',
            onPressed: () {
              _timer.cancel();
              _showLevelSelector();
            },
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
          ],
        ),
      ),
    );
  }

  void _showWinPopup() async
  {
    _timer.cancel();

    User? winner = await DatabaseHelper.fetchUserByName(widget.userName);

    if (winner != null) {
      int actualID = _currentLevelId;

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

  void _showLevelSelector() async {
    List<Wordladder> allLevels = await DatabaseHelper.fetchAllWordladders();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Select a Level',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 350,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.separated(
                itemCount: allLevels.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  int levelId = allLevels[index].id;
                  bool isSelected = _currentLevelId == levelId;

                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: isSelected ? Colors.deepPurple[100] : Colors.grey[100],
                    title: Text(
                      'Level $levelId',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.deepPurple : Colors.black,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      setState(() {
                        _currentLevelId = levelId;
                        hasSelectedLevel = true;
                      });
                      await _loadLevelById(levelId);
                    },
                  );
                },
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: hasSelectedLevel
            ? [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ]
            : [],
        );
      },
    );
  }

  Future<void> _loadLevelById(int id) async {
    try {
      final Wordladder? level = await DatabaseHelper.fetchWordladderById(id);
      if (level != null) {
        setState(() {
          wordList = level.wordList;
          currentWordLadder = hideWords(wordList);
          currentIndex = 1;
          score = 10000;
          incorrectGuesses = 0;
          secondsElapsed = 0;
          _startTimer();
        });
      }
    } catch (e) {
      print('Error loading level $id: $e');
    }
  }
}