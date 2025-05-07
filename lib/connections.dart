import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:team_19/db/databasehelper.dart';
import 'package:team_19/models/connections_model.dart';
import 'package:team_19/models/user_model.dart';

class ConnectionsGameScreen extends StatefulWidget {
  final String userName;
  const ConnectionsGameScreen({super.key, required this.userName});

  @override
  _ConnectionsGameScreenState createState() => _ConnectionsGameScreenState();
}

class _ConnectionsGameScreenState extends State<ConnectionsGameScreen> {
  Map<String, List<String>> categories = {'': ['']};
  List<String> words = [];
  List<String> selectedWords = [];
  Set<String> foundCategories = {};
  Map<String, List<String>> solvedWords = {}; // Category to its solved words
  int attemptsLeft = 4;
  bool isGameOver = false;

  Timer? _gameTimer;
  int secondsElapsed = 0;

  int _currentLevelId = 1;

  bool hasSelectedLevel = false;

  @override
  void initState() {
    super.initState();
    _showLevelSelector();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsElapsed < 999) {
        setState(() {
          secondsElapsed++;
        });
      } else {
        _gameTimer?.cancel();
      }
    });
  }

  void toggleSelection(String word) {
    if (foundCategories.any((cat) => categories[cat]!.contains(word))) {
      return;
    }
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else if (selectedWords.length < 4) {
        selectedWords.add(word);
      }
    });
  }

  void _showWinPopup() async {
    int attemptsTaken = 4 - attemptsLeft;
    int score = 10000 - (attemptsTaken * 2500) - (secondsElapsed * 10);

    User? winner = await DatabaseHelper.fetchUserByName(widget.userName);

    if (winner != null) {
      int actualID = _currentLevelId;

      bool savedNew = false;

      Map<int, int> winnerScores = winner.connectionsScores;
      
      if(winnerScores[actualID] != null)
      {
        if(winnerScores[actualID]! < score)
        {
          winnerScores[actualID] = score;
          winner.connectionsScores = winnerScores;

          savedNew = true;
        }
      }
      else
      {
        winnerScores[actualID] = score;
        winner.connectionsScores = winnerScores;

        savedNew = true;
      }

      if(savedNew)
      {
        Map<int, int> winnerTimes = winner.connectionsTimes;
        
        if(winnerTimes[actualID] != null)
        {
          if(winnerTimes[actualID]! > secondsElapsed)
          {
            winnerTimes[actualID] = secondsElapsed;
            winner.connectionsTimes = winnerTimes;
          }
        }
        else
        {
          winnerTimes[actualID] = secondsElapsed;
          winner.connectionsTimes = winnerTimes;
        }
      }


      await DatabaseHelper.updateUser(winner);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: Text('You found all categories!\nFinal Score: $score'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/connectionsleaderboard');
            },
            child: const Text('View Leaderboard'),
          )
        ],
      ),
    );
  }

  void checkSelection() {
    if (selectedWords.length == 4) {
      bool isCorrect = false;
      String foundCategoryName = '';
      bool oneAway = false;

      for (var entry in categories.entries) {
        Set<String> correctSet = entry.value.toSet();
        Set<String> selectionSet = selectedWords.toSet();

        if (selectionSet.containsAll(correctSet) &&
            correctSet.containsAll(selectionSet)) {
          isCorrect = true;
          foundCategoryName = entry.key;
          break;
        } else if (selectionSet.intersection(correctSet).length == 3) {
          oneAway = true;
        }
      }

      setState(() {
        if (isCorrect) {
          foundCategories.add(foundCategoryName);
          solvedWords[foundCategoryName] = selectedWords.toList();
          words.removeWhere((word) => selectedWords.contains(word));
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
          _gameTimer?.cancel();
          setState(() {
            isGameOver = true;
          });
          _showWinPopup();
        }

        if (attemptsLeft == 0) {
          _gameTimer?.cancel();
          setState(() {
            isGameOver = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Game Over! No attempts left.")),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  int getCategoryDifficulty(String category, Map<String, List<String>> categories) {
    List<String> orderedCategories = categories.keys.toList();

    int index = orderedCategories.indexOf(category);

    if (index == -1) {
      return 0;
    }

    return index + 1;
  }

  Color getCategoryColorFromName(String categoryName, Map<String, List<String>> categories) {
    int difficulty = getCategoryDifficulty(categoryName, categories);

    switch (difficulty) {
      case 1:
        return Colors.yellow;
      case 2:
        return const Color.fromARGB(255, 85, 225, 90);
      case 3:
        return Colors.blue;
      case 4:
        return const Color.fromARGB(255, 171, 64, 167);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wordWidgets = [];

    solvedWords.forEach((category, wordsList) {
      wordWidgets.add(
        Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: wordsList.map((word) => buildWordTile(word, true, getCategoryColorFromName(category, categories))).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.lerp(getCategoryColorFromName(category, categories), Colors.black, 0.45)!,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });

    wordWidgets.add(
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: words.map((word) => buildWordTile(word, false, Colors.grey[300]!)).toList(),
      ),
    );

    final TextStyle appBarTitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: const Text("Scattergories"),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: appBarTitleStyle,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
              _gameTimer?.cancel();
              _showLevelSelector();
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'How to Play',
            onPressed: () {
              _gameTimer?.cancel();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: const Text('How to Play Scattergories'),
                  content: const Text(
                    "Welcome to Scattergories!\n\n"
                    "🎭 You will be given a set of 16 words.\n\n"
                    "🪙 Your goal is to find four groups of four words that share a common theme.\n\n"
                    "4️⃣ Select four words that you think belong together and submit your guess.\n\n"
                    "✅ If correct, the words will be grouped together. If incorrect, you will receive a 'one away' hint if only one word is incorrect.\n\n"
                    "❎ You have a total of four incorrect attempts before the game ends.\n\n"
                    "🤔 Think critically about the relationships between words and find all the correct groups!",
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/images/connections_logo.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Attempts Left: $attemptsLeft",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: wordWidgets,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: (selectedWords.length == 4 && attemptsLeft > 0)
                  ? checkSelection
                  : null,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text("Submit", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildWordTile(String word, bool isSolved, Color backgroundColor) {
    bool isSelected = selectedWords.contains(word);

    // Create a lighter version of the background color
    Color lightBackgroundColor = Color.lerp(backgroundColor, Colors.white, 0.6)!;

    return GestureDetector(
      onTap: isSolved ? null : () => toggleSelection(word),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : lightBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: backgroundColor,  // Border color is original background color
            width: 3, // Make the border thicker
          ),
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
  }

   void _showLevelSelector() async {
    List<Connnection> allLevels = await DatabaseHelper.fetchAllConnections();
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
      final Connnection? level = await DatabaseHelper.fetchConnectionById(id);
      if (level != null) {
        setState(() {
          categories = level.categories;
          isGameOver = false;
          selectedWords = [];
          foundCategories = {};
          attemptsLeft = 4;
          secondsElapsed = 0;
          solvedWords = {};
          words = categories.values.expand((e) => e).toList();
          words.shuffle(Random());
          _startTimer();
        });
      }
    } catch (e) {
      print('Error loading level $id: $e');
    }
  }
}
