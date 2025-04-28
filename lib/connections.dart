import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:team_19/db/databasehelper.dart';
import 'package:team_19/models/connections_model.dart';

class ConnectionsGameScreen extends StatefulWidget {
  final String userName;
  const ConnectionsGameScreen({super.key, required this.userName});

  @override
  _ConnectionsGameScreenState createState() => _ConnectionsGameScreenState();
}

class _ConnectionsGameScreenState extends State<ConnectionsGameScreen> {
 /* Map<String, List<String>> categories = {
    "Colors": ["Red", "Blue", "Green", "Yellow"],
    "Fruits": ["Apple", "Banana", "Grape", "Orange"],
    "Animals": ["Dog", "Cat", "Horse", "Elephant"],
    "Instruments": ["Guitar", "Piano", "Violin", "Drums"]
  };*/

  Map<String, List<String>> categories = {'':['']};

  List<String> words = [];
  List<String> selectedWords = [];
  Set<String> foundCategories = {};
  Map<String, List<String>> solvedWords = {}; // Category to its solved words
  int attemptsLeft = 4;
  bool isGameOver = false;

  Timer? _gameTimer;
  int elapsedSeconds = 0;

  int _currentLevelId = 1;

  @override
  void initState() {
    super.initState();
    _loadLevel();
    _startTimer(); // Start the timer when the game begins
  }


  Future<void> _loadLevel() async {
    try {
    final Connnection? level = await DatabaseHelper.fetchConnectionById(_currentLevelId);

    if (level != null) {
      setState(() {
        categories = level.categories;
        _currentLevelId++; // Move to next level for next time
        words = categories.values.expand((e) => e).toList();
        words.shuffle(Random());
      });
    } else {
      setState(() {
        categories = {'':['']};
      });
    }
  } catch (e) {
    setState(() {
      categories = {'':['']};
    });
    print('Error loading Scatergories level: $e');
  }
  }

  Future<void> _loadNextLevel() async {
    setState(() {
      isGameOver = false; 
      selectedWords = [];
      foundCategories = {};
      attemptsLeft = 4;
      elapsedSeconds = 0;
      _startTimer();     
    });
    await _loadLevel();        
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (elapsedSeconds < 999) {
        setState(() {
          elapsedSeconds++;
        });
      } else {
        _gameTimer?.cancel();
      }
    });
  }

  void toggleSelection(String word) {
    if (foundCategories.any((cat) => categories[cat]!.contains(word))) {
      return; // Can't select words from already found categories
    }
    setState(() {
      if (selectedWords.contains(word)) {
        selectedWords.remove(word);
      } else if (selectedWords.length < 4) {
        selectedWords.add(word);
      }
    });
  }

  void showWinPopup() {
    int attemptsTaken = 4 - attemptsLeft;
    int score = 10000 - (attemptsTaken * 2500) - (elapsedSeconds * 10);

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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Category Found: $foundCategoryName")),
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
          setState(() {
            isGameOver = true;
          });
          showWinPopup(attemptsLeft);
        }

        if (attemptsLeft == 0) {
          _gameTimer?.cancel(); // Stop the timer when out of attempts
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

  Color getCategoryColor(String category) {
    switch (category) {
      case "Colors":
        return Colors.redAccent;
      case "Fruits":
        return const Color.fromARGB(255, 85, 225, 90);
      case "Animals":
        return const Color.fromARGB(255, 149, 16, 144);
      case "Instruments":
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wordWidgets = [];

    // Add completed groups first
    solvedWords.forEach((category, wordsList) {
      wordWidgets.add(
        Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: wordsList.map((word) => buildWordTile(word, true, getCategoryColor(category))).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: getCategoryColor(category),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });

    // Add remaining unsolved words randomly
    wordWidgets.add(
      Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: words.map((word) => buildWordTile(word, false, Colors.grey[300]!)).toList(),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scattergories"),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: Text(
                "⏱️ $elapsedSeconds s",
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
                    "You will be given 16 words.\n\n"
                    "Find 4 groups of 4 related words.\n\n"
                    "You have 4 total incorrect attempts.\n\n"
                    "Select 4 words and submit!",
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

      
      // HUGE MERGE CONFLICT HERE, MAY NEED RESOLVING
      
//<<<<<<< connections-final-version
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "Player: ${widget.userName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
//=======
      body: categories.isEmpty
      ? Center(child: CircularProgressIndicator())
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Image.asset(
            'assets/images/connections_logo.png',
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Prevents the user from scrolling, they should have no need to 
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 4, // May need to adjust to fit more nicely in the future if more things get added to the page
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
//>>>>>>> dev

      
                ),
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
          ),
          const SizedBox(height: 40),
          if (isGameOver)
            ElevatedButton(
              onPressed: _loadNextLevel,
              child: Text('Next Level'),
            )
        ],
      ),
    );
  }

  Widget buildWordTile(String word, bool isSolved, Color backgroundColor) {
    bool isSelected = selectedWords.contains(word);

    return GestureDetector(
      onTap: isSolved ? null : () => toggleSelection(word),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : backgroundColor,
          borderRadius: BorderRadius.circular(12),
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
  }
}
