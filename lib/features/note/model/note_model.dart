// class NoteModel {
//   final int id;
//   final String title;
//   final String content;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final bool isFavourite;
//   final bool isPinned;
//   final int categoryId;

//   const NoteModel({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.isPinned,
//     required this.isFavourite,
//     required this.categoryId,
//   });
// }

class NoteModel {
  final String id;
  final String title;
  final String? content;
  final String? description;
  final String? tomorrowTasks;
  final int? v;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavourite;
  final bool isPinned;
  final int categoryId;

  const NoteModel({
    required this.id,
    required this.title,
    this.content,
    this.description,
    this.tomorrowTasks,
    this.v,
    required this.createdAt,
    required this.updatedAt,
    this.isFavourite = false,
    this.isPinned = false,
    this.categoryId = 0,
  });

  factory NoteModel.fromMap(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'],
      description: json['description'],
      tomorrowTasks: json['tommorow_tasks'],
      v: json['__v'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      isFavourite: json['isFavourite'] ?? false,
      isPinned: json['isPinned'] ?? false,
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'description': description,
      'tommorow_tasks': tomorrowTasks,
      '__v': v,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavourite': isFavourite,
      'isPinned': isPinned,
      'categoryId': categoryId,
    };
  }
}
