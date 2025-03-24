import 'package:flutter/material.dart';

void main() {
  runApp(LetterQuestGame());
}

class LetterQuestGame extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("LetterQuest")),
        body: Center(
          child: LetterQuestPhraseDisplay(
            phrase: "HELLO WORLD",
            hint: "A common greeting",
          ),
        ),
      ),
    );
  }
}

class LetterQuestPhraseDisplay extends StatelessWidget {
  final String phrase;
  final String hint;

  const LetterQuestPhraseDisplay({
    Key? key,
    required this.phrase,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: phrase.split('').map((char) {
            return char == ' '
                ? SizedBox(width: 16.0) // Space representation
                : Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 2.0)),
                    ),
                    child: Text(
                      '_',
                      style: TextStyle(
                        fontSize: _calculateFontSize(context, phrase.length),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
          }).toList(),
        ),
        SizedBox(height: 20.0),
        Container(
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            hint,
            style: TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  double _calculateFontSize(BuildContext context, int length) {
    double baseSize = 24.0;
    return (length > 15) ? baseSize - (length - 15) * 0.5 : baseSize;
  }
}