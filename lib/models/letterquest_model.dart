class Letterquest{
  final int id;
  final String phrase;
  final String hint;

  const Letterquest({required this.phrase, required this.hint, required this.id});

  factory Letterquest.fromJson(Map<String,dynamic> json) => Letterquest(
    id: json['id'],
    phrase: json['phrase'],
    hint: json['hint']
  );

  Map<String,dynamic> toJson() => {
    'id': id,
    'phrase': phrase,
    'hint': hint
  };
}