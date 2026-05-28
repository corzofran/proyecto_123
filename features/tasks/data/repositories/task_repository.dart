import 'package:proyecto_123/core/network/api_client.dart';
import 'package:proyecto_123/core/constants/app_constants.dart';
import 'package:proyecto_123/features/tasks/data/models/task_model.dart';

class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository(this._apiClient);

  Future<List<TaskModel>> getTasks() async {
    final List<dynamic> response = await _apiClient.get(AppConstants.tasksEndpoint);
    // Limitamos a 20 para el ejemplo
    return response.take(20).map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await _apiClient.post(AppConstants.tasksEndpoint, task.toJson());
    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _apiClient.put('${AppConstants.tasksEndpoint}/${task.id}', task.toJson());
    return TaskModel.fromJson(response);
  }

  Future<void> deleteTask(int id) async {
    await _apiClient.delete('${AppConstants.tasksEndpoint}/$id');
  }
}
