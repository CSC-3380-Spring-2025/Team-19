import 'dart:convert';

class Connnection {
  final int id;
  final Map<String, List<String>> categories;

  const Connnection({required this.categories, required this.id});

  factory Connnection.fromJson(Map<String, dynamic> json) {
    final rawCategories = json['categories'];
    Map<String, List<String>> parsedCategories;

    if (rawCategories is String) {
      final decoded = jsonDecode(rawCategories) as Map<String, dynamic>;
      parsedCategories = decoded.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );
    } else if (rawCategories is Map<String, dynamic>) {
      parsedCategories = rawCategories.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      );
    } else {
      throw FormatException('Invalid format for categories');
    }

    return Connnection(
      id: json['id'],
      categories: parsedCategories,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categories': jsonEncode(categories),
      };
}
