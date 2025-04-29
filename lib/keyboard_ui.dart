import 'package:flutter/material.dart';


// THIS IS NOT USED IN WORDLADDER, ONLY IN LETTERQUEST
class WordLadderKeyboard extends StatelessWidget {
  final Set<String> guessedLetters;
  final String phrase;
  final VoidCallback onEnter;
  final VoidCallback onDelete;
  final Function(String) onKeyPress;

  const WordLadderKeyboard({
    super.key,
    required this.guessedLetters,
    required this.phrase,
    required this.onEnter,
    required this.onDelete,
    required this.onKeyPress,
  });

  static const List<String> _qwertyLayout = [
    "QWERTYUIOP",
    "ASDFGHJKL",
    "ZXCVBNM"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[100],
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._qwertyLayout.map(_buildKeyRow),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ],
      ),
    );
  }

  Widget _buildKeyRow(String row) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.split('').map((char) => _buildKey(char)).toList(),
    );
  }

  Widget _buildKey(String char) {
    bool isGuessed = guessedLetters.contains(char);
    Color bgColor = isGuessed
        ? (phrase.contains(char) ? Colors.green : Colors.grey)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: isGuessed ? null : () => onKeyPress(char),
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: Colors.black,
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
        ),
        child: Text(char, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
