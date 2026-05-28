class TaskModel {
  final int? id;
  final String title;
  final bool completed;
  final int userId;

  TaskModel({
    this.id,
    required this.title,
    this.completed = false,
    this.userId = 1,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] ?? false,
      userId: json['userId'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'userId': userId,
    };
  }

  TaskModel copyWith({
    int? id,
    String? title,
    bool? completed,
    int? userId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }
}
