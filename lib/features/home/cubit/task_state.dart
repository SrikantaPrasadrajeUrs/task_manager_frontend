part of 'task_cubit.dart';

sealed class TaskState{

}

class TaskInitial extends TaskState{}

class TaskSuccess extends TaskState{
  final List<TaskModel> tasks;
  TaskSuccess(this.tasks);
}

class TaskLoading extends TaskState{}

class TaskFailure extends TaskState{
  final String error;
  TaskFailure(this.error);
}

class AddTaskSuccess extends TaskState{

}

final class GetTasksSuccess extends TaskState {
  final List<TaskModel> tasks;
  GetTasksSuccess(this.tasks);
}

final class TaskWarning extends TaskState{
  final String message;
  TaskWarning(this.message);
}

final class TaskSyncSuccess extends TaskState{}

final class TaskSyncFailure extends TaskState{}