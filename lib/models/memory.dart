enum MemoryType {
  memory,
  recipe
}

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
  final MemoryType type;

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
    this.type = MemoryType.memory,
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
      type: json['type'] != null 
          ? MemoryType.values[json['type'] as int] 
          : MemoryType.memory,
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
      'type': type.index,
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
    MemoryType? type,
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
      type: type ?? this.type,
    );
  }
}