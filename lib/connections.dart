import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const ConnectionsGameApp());
}

class ConnectionsGameApp extends StatelessWidget {
  const ConnectionsGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConnectionsGameScreen(),
    );
  }
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

  @override
  void initState() {
    super.initState();
    words = categories.values.expand((e) => e).toList();
    words.shuffle(Random());
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

  void checkSelection() {
    if (selectedWords.length == 4) {
      bool isCorrect = false;
      bool oneAway = false;
      
      for (var category in categories.values) {
        Set<String> correctSet = category.toSet();
        Set<String> selectionSet = selectedWords.toSet();
        
        if (selectionSet.containsAll(correctSet) && correctSet.containsAll(selectionSet)) {
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

        if (attemptsLeft == 0) {
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
      appBar: AppBar(title: const Text("Connections")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Attempts Left: $attemptsLeft", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
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
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: (selectedWords.length == 4 && attemptsLeft > 0) ? checkSelection : null,
              child: const Text("Submit", style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
