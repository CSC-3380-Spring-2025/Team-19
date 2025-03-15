import 'package:flutter/material.dart';


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
  List<String> words = [
    "Apple", "Banana", "Cherry", "Date",
    "Red", "Blue", "Green", "Yellow",
    "Cat", "Dog", "Horse", "Elephant",
    "Guitar", "Piano", "Violin", "Drums"
  ];


  List<String> selectedWords = [];


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
      // TODO: Implement actual category checking logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Checking selection...")),
      );
      setState(() {
        selectedWords.clear();
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
          const SizedBox(height: 50),
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
          const SizedBox(height: 20), // Space before the button
          SizedBox(
            width: 200, // Wider button
            height: 50, // Taller button
            child: ElevatedButton(
              onPressed: selectedWords.length == 4 ? checkSelection : null,
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 18), // Bigger text
              ),
            ),
          ),
          const SizedBox(height: 200), // Extra spacing at the bottom
        ],
      ),
    );
  }
}
