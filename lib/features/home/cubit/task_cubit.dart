import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/custom_exception/custom_exception.dart';
import 'package:task_manager/core/custom_exception/network_exception.dart';
import 'package:task_manager/core/utils/utils.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/features/home/repository/task_remote_repository.dart';
import 'package:uuid/uuid.dart';

import '../repository/task_local_repository.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  DateTime selectedDate = DateTime.now();
  final TaskRemoteRepository _taskRemoteRepository = TaskRemoteRepositoryImpl();
  final TaskLocalRepository _taskLocalRepository = TaskLocalRepositoryImpl();
  Set<TaskModel> _tasks = {};
  TaskCubit() : super(TaskInitial());

  void addTask(
      {required String title,
      required String description,
      required DateTime dueAt,
      required String uid,
      required Color hexColor}) async {
    try {
      emit(TaskLoading());
      final response = await _taskRemoteRepository.addTask({
        'title': title,
        'description': description,
        'dueAt': dueAt.toIso8601String(),
        'hexColor': rgbToHex(hexColor),
      });
      if (response is TaskModel) {
        await _taskLocalRepository.insertTask(response);
        _tasks.add(response);
        emit(AddTaskSuccess());
        emit(GetTasksSuccess(_filterTaskByDate(_tasks)));
      } else {
        emit(TaskFailure("Task adding failed"));
      }
    } on NetworkException catch (e) {
      final task = TaskModel(
        id: const Uuid().v6(),
        uid: uid,
        hexColor: rgbToHex(hexColor),
        title: title,
        description: description,
        dueAt: dueAt,
        isSynced: 0,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await _taskLocalRepository.insertTask(task);
      _tasks.add(task);
      emit(AddTaskSuccess());
      selectedDate = DateTime.now();
      emit(GetTasksSuccess(_filterTaskByDate(_tasks)));
      emit(TaskWarning("Mobile is not Connected to any network"));
    } catch (e,st) {
      sessionExpiredPopUp(e);
      if(e is! StatusCodeException)emit(TaskFailure(e.toString()));
    }
  }

  void onDateSelected(DateTime date) {
    selectedDate = date;
    emit(GetTasksSuccess(_filterTaskByDate(_tasks)));
  }

  List<TaskModel> _filterTaskByDate(Set<TaskModel> tasks) {
    return tasks.where((task) {
      return task.dueAt.day == selectedDate.day &&
          task.dueAt.month == selectedDate.month &&
          task.dueAt.year == selectedDate.year;
    }).toList();
  }

  void getAllTasks() async {
    try {
      emit(TaskLoading());
      final response = await _taskRemoteRepository.getAllTasks();
      if (response is List<TaskModel>) {
        _tasks = {...response};
        _taskLocalRepository.insertTasks(response);
        emit(GetTasksSuccess(_filterTaskByDate(_tasks)));
      } else {
        emit(TaskFailure("Failed to get tasks"));
      }
    } on NetworkException catch (e) {
      final tasks = await _taskLocalRepository.getTasks();
      if (tasks != null) {
        _tasks = {...tasks};
        emit(GetTasksSuccess(_filterTaskByDate(_tasks)));
      } else {
        emit(TaskFailure("Offline access failed"));
      }
    } catch (e) {
      sessionExpiredPopUp(e);
      emit(TaskFailure(e.toString()));
    }
  }

  void deleteTask(String taskId) async {
    try {
      final response = await _taskRemoteRepository.deleteTask(taskId);
      if (response) {
        _tasks.removeWhere((task) => task.id == taskId);
        final didDelete = await _taskLocalRepository.deleteTask(taskId);
        if (!didDelete) {
          emit(TaskWarning("Failed to sync tasks"));
        }
        emit(GetTasksSuccess(_filterTaskByDate(_tasks)));
        return;
      }
      emit(TaskFailure("Error deleting task"));
    } on NetworkException catch (e) {
      emit(TaskWarning("Mobile is not Connected to any network"));
    }
    catch (e) {
      sessionExpiredPopUp(e);
      emit(TaskFailure("Error deleting task $e"));
    }
  }

  void syncTasks()async{
    try{
     final tasks = await _taskLocalRepository.getUnSyncedTasks();
     if(tasks.isNotEmpty){
       List<Map<String,dynamic>> tasksMap = [];
       for(Map<String,dynamic> task in tasks){
         tasksMap.add({
           if(task['id'].toString().isNotEmpty)'id':task['id'],
           'title': task['title'],
           'description': task['description'],
           'dueAt': task['dueAt'],
           'hexColor': task['hexColor'],
         });
       }
       final response = await _taskRemoteRepository.syncTasks(tasksMap);
      if(response!=null&&response['tasksData'] is List){
        final syncedTasks = (response['tasksData'] as List).map((task)=>TaskModel.fromMap(task));
          await _taskLocalRepository.updateIsSynced(syncedTasks.map((task) => task.id).toList());
          emit(TaskSyncSuccess());
          _tasks.addAll(syncedTasks);
      }
     }
    }catch(e,st){
      emit(TaskSyncFailure());
      emit(TaskFailure("Online sync failed"));
    }
  }
}
