class TaskModel {
  final int? id;
  final String title;
  final bool completed;

  TaskModel({
    this.id,
    required this.title,
    this.completed = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      // Soporta 'id' o '_id' según tu DB de la tarea
      id: json['id'] ?? json['_id'],
      // Soporta 'title' o 'titulo'
      title: json['title'] ?? json['titulo'] ?? 'Sin título',
      // Soporta 'completed' o 'completado'
      completed: json['completed'] ?? json['completado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  TaskModel copyWith({int? id, String? title, bool? completed}) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
