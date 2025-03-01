import 'package:task_manager/core/constants/config.dart';
import 'package:task_manager/core/services/http_service.dart';
import '../../../core/constants/endpoints.dart';
import '../../../data/models/task_model.dart';

sealed class TaskRemoteRepository {
  Future<dynamic> addTask(Map<String,dynamic> task);
  Future<bool> deleteTask(String taskId);
  Future<dynamic> getAllTasks();
  Future<dynamic> syncTasks(List<Map<String,dynamic>> tasks);
}

class TaskRemoteRepositoryImpl implements TaskRemoteRepository {
  @override
  Future<dynamic> addTask(Map<String,dynamic> task) async {
    final response = await HTTPService.post(
        "$domain${Endpoints.task}",
        statusCode: 201,
        task,
        wantException: true);
    if (response != null && response is Map) {
      return TaskModel.fromMap(response['taskData']);
    }
  }

  @override
  Future<bool> deleteTask(String taskId) async {
    final response = await HTTPService.delete(
      "$domain${Endpoints.task}$taskId",
      wantException: true
    );
    if (response != null) {
      return true;
    }
    return false;
  }

  @override
  Future<List<TaskModel>?> getAllTasks() async {
    final response = await HTTPService.get(
      "$domain${Endpoints.task}",
      wantException: true
    );
    if (response != null && response is Map) {
      return ((response['taskData'] ?? []) as List).map((task) => TaskModel.fromMap(task)).toList();
    }
    return null;
  }

  @override
  Future<dynamic> syncTasks(List<Map<String,dynamic>> tasks) async {
    return await HTTPService.post("$domain${Endpoints.syncTasks}", {
      "tasks":tasks
    },statusCode: 201);
  }
}
