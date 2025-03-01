import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/constants/enums.dart';
import 'package:task_manager/core/utils/sp_helper.dart';
import 'package:task_manager/features/auth/views/welcome.dart';
import 'package:task_manager/features/home/widgets/date_selector.dart';
import 'package:task_manager/features/home/views/add_task.dart';
import 'package:task_manager/main.dart';
import '../../../core/utils/utils.dart';
import '../widgets/task_card.dart';
import '../cubit/task_cubit.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void navigateToAddTask(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTask()));
  }

  void navigateToWelcomePage(BuildContext context) {
    SpHelper().setToken("");
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Welcome()));
  }

  void syncTasksOnConnectionChange(){
    Connectivity().onConnectivityChanged.listen((data){
      if(data.contains(ConnectivityResult.wifi)||data.contains(ConnectivityResult.mobile)){
        navigatorKey.currentContext!.read<TaskCubit>().syncTasks();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getAllTasks();
    syncTasksOnConnectionChange();
  }

  void handleTaskDelete(String taskId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Confirm Delete",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to delete this task? This action cannot be undone.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context); // Close dialog first
                context.read<TaskCubit>().deleteTask(taskId); // Perform delete action
              },
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
        leadingWidth: 50,
        leading: GestureDetector(
          onTap: ()=>navigateToWelcomePage(context),
          child: const Icon(Icons.exit_to_app_rounded),
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigateToAddTask(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: ConstantSizes.horizontalPadding),
        child: BlocConsumer<TaskCubit, TaskState>(listener: (context, state) {
          if (state is TaskFailure) {
            showSnackBar(state.error, context);
          }
          if (state is AddTaskSuccess) {
            showSnackBar("Task added successfully", context);
          }
          if (state is TaskFailure) {
            showSnackBar(state.error, context);
          }
          if(state is TaskWarning){
            showSnackBar(state.message, context);
          }
          if(state is TaskSyncSuccess){
            showSnackBar("Tasks synced successfully", context);
          }
          if(state is TaskSyncFailure) {
            showSnackBar("Tasks syncing failed", context);
          }
        },
            buildWhen: (prev,curr){
              return curr is GetTasksSuccess ||curr is TaskLoading;
            },
            builder: (context, state) {
          if (state is TaskLoading) {
            return centerLoader();
          }
          if(state is GetTasksSuccess){
            final tasks = state.tasks;
            return Column(
              children: [
                const SizedBox(height: 10),
                const DateSelector(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context,index) {
                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onLongPress: ()=>handleTaskDelete(tasks[index].id),
                              child: TaskCard(
                                    color: hexToRgb(tasks[index].hexColor),
                                    title: tasks[index].title,
                                    description: tasks[index].description),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: strengthenColor(hexToRgb(tasks[index].hexColor), 0.69),
                            ),
                          ),
                          Column(
                            children: [
                              Text(" ${DateFormat.jm().format(tasks[index].dueAt)}"),
                            ],
                          )
                        ],
                      );
                    }
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              const SizedBox(height: 10),
              const DateSelector(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                      child: TaskCard(
                          color: Color.fromRGBO(246, 222, 194, 1),
                          title: "Task 1",
                          description: "Description 1")),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: strengthenColor(
                          const Color.fromRGBO(246, 222, 194, 1), 0.69),
                    ),
                  ),
                  const Text(" 11.00am")
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
