class Memory {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime date;
  final String? imagePath;
  final String? videoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  Memory({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.date,
    this.imagePath,
    this.videoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create a Memory from JSON data
  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      imagePath: json['imagePath'] as String?,
      videoPath: json['videoPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert Memory to JSON data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
      'videoPath': videoPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create a copy of Memory with some fields updated
  Memory copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? date,
    String? imagePath,
    String? videoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Memory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}