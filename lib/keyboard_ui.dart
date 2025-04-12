import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Word Ladder Keyboard")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            WordLadderKeyboard(
              onEnter: () => print("Enter Pressed"),
              onDelete: () => print("Delete Pressed"),
              onKeyPress: (key) => print("Key Pressed: $key"),
            ),
          ],
        ),
      ),
    );
  }
}

class WordLadderKeyboard extends StatelessWidget {
  final VoidCallback onEnter;
  final VoidCallback onDelete;
  final Function(String) onKeyPress;

  WordLadderKeyboard({
    required this.onEnter,
    required this.onDelete,
    required this.onKeyPress,
  });

  @override
  Widget build(BuildContext context) {
    List<String> keys = [
      'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
      'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
      'Z', 'X', 'C', 'V', 'B', 'N', 'M'
    ];

    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.grey[300],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(keys.sublist(0, 10)),
          _buildRow(keys.sublist(10, 19), padding: true),
          _buildBottomRow(keys.sublist(19, 26)),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> letters, {bool padding = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ? 16.0 : 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((letter) => _buildKey(letter)).toList(),
      ),
    );
  }

  Widget _buildBottomRow(List<String> letters) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSpecialKey("Enter", onEnter),
        ...letters.map((letter) => _buildKey(letter)),
        _buildSpecialKey("Delete", onDelete),
      ],
    );
  }

  Widget _buildKey(String letter) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () => onKeyPress(letter),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          minimumSize: Size(42, 42),
        ),
        child: Text(letter, style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Widget _buildSpecialKey(String label, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          minimumSize: Size(72, 42),
        ),
        child: Text(label, style: TextStyle(fontSize: 18)),
      ),
    );
  }
}