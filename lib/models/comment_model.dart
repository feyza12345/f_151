class CommentModel {
  final String name;
  final int stars;
  final String comment;
  final DateTime dateTime;

  CommentModel({
    required this.name,
    required this.stars,
    required this.comment,
    required this.dateTime,
  });

  CommentModel copyWith({
    String? name,
    int? stars,
    String? comment,
    DateTime? dateTime,
  }) {
    return CommentModel(
      name: name ?? this.name,
      stars: stars ?? this.stars,
      comment: comment ?? this.comment,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'stars': stars,
      'comment': comment,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      name: map['name'] as String,
      stars: map['stars'] as int,
      comment: map['comment'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
    );
  }
}
