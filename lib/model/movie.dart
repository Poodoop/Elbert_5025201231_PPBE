final String tableMovie = 'movies';

class MovieFields {
  static final List<String> values = [
    /// Add all fields
    id, title, description, imageURL, time
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String imageURL = 'imageURL';
  static final String time = 'time';
}

class Movie {
  final int? id;
  final String title;
  final String description;
  final String imageURL;
  final DateTime createdTime;

  const Movie({
    this.id,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.createdTime,
  });

  Movie copy({
    int? id,
    String? title,
    String? description,
    String? imageURL,
    DateTime? createdTime,
  }) =>
      Movie(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageURL: imageURL ?? this.imageURL,
        createdTime: createdTime ?? this.createdTime,
      );

  static Movie fromJson(Map<String, Object?> json) => Movie(
    id: json[MovieFields.id] as int?,
    title: json[MovieFields.title] as String,
    description: json[MovieFields.description] as String,
    imageURL: json[MovieFields.imageURL] as String,
    createdTime: DateTime.parse(json[MovieFields.time] as String),
  );

  Map<String, Object?> toJson() => {
    MovieFields.id: id,
    MovieFields.title: title,
    MovieFields.description: description,
    MovieFields.imageURL: imageURL,
    MovieFields.time: createdTime.toIso8601String(),
  };
}