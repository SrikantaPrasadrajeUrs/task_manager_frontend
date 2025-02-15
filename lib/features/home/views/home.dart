import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/constants/enums.dart';
import 'package:task_manager/features/home/components/date_selector.dart';
import 'package:task_manager/features/home/views/add_task.dart';

import '../../../core/utils/utils.dart';
import '../components/task_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void navigateToAddTask(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddTask()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            navigateToAddTask(context);
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal : ConstantSizes.horizontalPadding),
        child: Column(
            children: [
              const SizedBox(height: 10),
              const DateSelector(),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(child: TaskCard(color: Color.fromRGBO(246, 222, 194, 1), title: "Task 1", description: "Description 1")),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: strengthenColor(const Color.fromRGBO(246, 222, 194, 1), 0.69),
                    ),
                  ),
                  const Text(" 11.00am")
                ],
              ),
            ],
        ),
      ),
    );
  }
}
