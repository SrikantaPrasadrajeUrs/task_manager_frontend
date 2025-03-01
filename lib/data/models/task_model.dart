
class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime dueAt;
  final String? createdAt;
  final String hexColor;
  final String? updatedAt;
  final String? uid;
  final int isSynced;

  TaskModel({
    this.uid,
    required this.id,
    required this.hexColor,
    required this.title,
    required this.description,
    required this.dueAt,
    required this.isSynced,
    this.updatedAt,
    this.createdAt
  });

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? dueAt,
    String? createdAt,
    String? updatedAt,
    String? hexColor,
    int? isSynced
  }) {
    return TaskModel(
      id: id,
      uid: uid,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      hexColor: hexColor??this.hexColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced?? this.isSynced
    );
  }

   static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      uid: map['uid'] as String,
      hexColor: map['hexColor'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      dueAt: DateTime.parse(map['dueAt'] as String),
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      isSynced: map['isSynced'] ?? 1,
    );
  }

  Map<String, dynamic> toMap({bool requireCreatedAt = false, bool requireUpdatedAt = false, bool requireSynced = false}) {
    final timeStamp = {
      if(requireCreatedAt)"createdAt": DateTime.now().toIso8601String(),
      if(requireUpdatedAt)"updatedAt": DateTime.now().toIso8601String(),
    };
    return {
      "id":id,
      'uid': uid,
      'title': title,
      'description': description,
      'dueAt': dueAt.toIso8601String(),
      'hexColor': hexColor,
      if(requireSynced) "isSynced": isSynced,
      if(requireCreatedAt||requireUpdatedAt)...timeStamp
    };
  }

  @override
  String toString() {
    return 'TaskModel(title: $title, description: $description, dueAt: $dueAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if(identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
