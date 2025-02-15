import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/enums.dart';
import '../../../core/utils/utils.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Color selectedColor = const Color.fromRGBO(246, 222, 194, 1);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void handleTaskSubmit(){
    if(_titleController.text.isEmpty){
      showSnackBar("Title cannot be empty", context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()=>Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text("Add New Task"),
        centerTitle: true,
        actions: [
          GestureDetector(onTap: ()async{
            final newDate = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 90)));
            if(newDate!=null){
              setState(() {
                selectedDate = newDate;
              });
            }
          }, child:Text("${DateFormat("MM-dd-yyyy").format(selectedDate)}  "))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:ConstantSizes.horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(color: Colors.black54)
              ),
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                alignLabelWithHint: true,
                labelStyle: TextStyle(color: Colors.black54)
              ),
            ),
            ColorPicker(
                heading: const Text("Select a color"),
                subheading: const Text("Select a shade"),
                pickersEnabled: const {
                  ColorPickerType.accent: true,
                  ColorPickerType.wheel:true
                },
                onColorChanged: (color){
              setState(() {
                selectedColor = color;
              });
            }),
            const SizedBox(height: 10,),
            ElevatedButton(onPressed:handleTaskSubmit, child: const Text(""
                "Submit", style: TextStyle(fontSize: 17,color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
