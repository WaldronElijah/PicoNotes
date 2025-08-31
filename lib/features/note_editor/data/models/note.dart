class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  // final List<String> mediaReferences; // Temporarily commented out
  // final List<String> tags; // Temporarily commented out

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    // this.mediaReferences = const [], // Temporarily commented out
    // this.tags = const [], // Temporarily commented out
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    // List<String>? mediaReferences, // Temporarily commented out
    // List<String>? tags, // Temporarily commented out
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      // mediaReferences: mediaReferences ?? this.mediaReferences, // Temporarily commented out
      // tags: tags ?? this.tags, // Temporarily commented out
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
      // Temporarily commented out until we add these columns
      // 'media_references': mediaReferences,
      // 'tags': tags,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String,
      // Temporarily commented out until we add these columns
      // mediaReferences: List<String>.from(json['media_references'] ?? []),
      // tags: List<String>.from(json['tags'] ?? []),
    );
  }

  factory Note.create({
    required String title,
    required String content,
    required String userId,
    // List<String> mediaReferences = const [], // Temporarily commented out
    // List<String> tags = const [], // Temporarily commented out
  }) {
    final now = DateTime.now();
    return Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
      userId: userId,
      // mediaReferences: mediaReferences, // Temporarily commented out
      // tags: tags, // Temporarily commented out
    );
  }
}
