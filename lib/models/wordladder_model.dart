import 'dart:convert';

class Wordladder {
  final int id;
  final List<String> wordList;

  const Wordladder({required this.wordList, required this.id});

  factory Wordladder.fromJson(Map<String, dynamic> json) {
    final rawWordList = json['wordList'];

    List<String> parsedList;
    if (rawWordList is String) {
      parsedList = List<String>.from(jsonDecode(rawWordList));
    } else if (rawWordList is List) {
      parsedList = List<String>.from(rawWordList);
    } else {
      throw FormatException('Invalid format for wordList');
    }

    return Wordladder(
      id: json['id'],
      wordList: parsedList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'wordList': jsonEncode(wordList),
      };
}
