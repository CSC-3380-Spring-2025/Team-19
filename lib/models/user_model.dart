import 'dart:convert';

class User {
  final String name;
  final Map<int, int> connectionsScores;
  final Map<int, int> connectionsTimes;
  final Map<int, int> letterquestScores;
  final Map<int, int> letterquestTimes;
  final Map<int, int> wordladderScores;
  final Map<int, int> wordladderTimes;

  const User({
    required this.name,
    required this.connectionsScores,
    required this.connectionsTimes,
    required this.letterquestScores,
    required this.letterquestTimes,
    required this.wordladderScores,
    required this.wordladderTimes,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        connectionsScores: _decodeMap(json['connectionsScores']),
        connectionsTimes: _decodeMap(json['connectionsTimes']),
        letterquestScores: _decodeMap(json['letterquestScores']),
        letterquestTimes: _decodeMap(json['letterquestTimes']),
        wordladderScores: _decodeMap(json['wordladderScores']),
        wordladderTimes: _decodeMap(json['wordladderTimes']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'connectionsScores': _encodeMap(connectionsScores),
        'connectionsTimes': _encodeMap(connectionsTimes),
        'letterquestScores': _encodeMap(letterquestScores),
        'letterquestTimes': _encodeMap(letterquestTimes),
        'wordladderScores': _encodeMap(wordladderScores),
        'wordladderTimes': _encodeMap(wordladderTimes),
      };

  static Map<int, int> _decodeMap(dynamic input) {
    if (input is String) {
      final decoded = jsonDecode(input) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(int.parse(key), value as int));
    } else if (input is Map<String, dynamic>) {
      return input.map((key, value) => MapEntry(int.parse(key), value as int));
    } else {
      throw FormatException('Invalid format for Map<int, int>');
    }
  }

  static String _encodeMap(Map<int, int> map) {
    return jsonEncode(map.map((key, value) => MapEntry(key.toString(), value)));
  }
}
