import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';

void main() {
  runApp(MaterialApp(
    home: TaskManagementApp(),
  ));
}

enum TaskCategory { Personal, Academic, Work, Other }

class TaskManagementApp extends StatefulWidget {
  @override
  _TaskManagementAppState createState() => _TaskManagementAppState();
}

class _TaskManagementAppState extends State<TaskManagementApp> {
  List<TaskModel> tasks = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  int selectedPriority = 0; // Default priority is Low
  TaskCategory? selectedCategory;

  String getPriorityText(int priority) {
    switch (priority) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Unknown';
    }
  }

  void getTasks() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot =
        await TaskModel.readAll();
    print('snapshot: $snapshot');
    snapshot.listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<Map<String, dynamic>> documents =
          snapshot.docs.map((document) => document.data()).toList();
      print('documents: $documents');

      try {
        List<TaskModel> tasks =
            documents.map((document) => TaskModel.fromJson(document)).toList();
        print('tasks: $tasks');
        setState(() {
          this.tasks = tasks;
        });
      } catch (e) {
        print('error in getting tasks' + e.toString());
      }
    });
  }

  void addTask() {
    print('adding task');
    String title = titleController.text;
    String description = descriptionController.text;
    String dueDate = selectedDate != null
        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
        : '';
    int priority = selectedPriority;
    String category = selectedCategory != null
        ? selectedCategory.toString().split('.').last
        : '';

    TaskModel newTask = TaskModel(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      category: category,
      isCompleted: false,
    );

    try {
      newTask.save();
      setState(() {
        titleController.clear();
        descriptionController.clear();
        selectedDate = null;
        selectedPriority = 0; 
        selectedCategory = null;
      });
    } catch (e) {
      print('error in saving' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Add a Task',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextField(titleController, 'Task Title'),
            const SizedBox(height: 10),
            _buildTextField(descriptionController, 'Task Description'),
            const SizedBox(height: 10),
            _buildDateSelector(context),
            const SizedBox(height: 10),
            _buildCategorySelector(context),
            const SizedBox(height: 10),
            _buildPrioritySelection(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addTask();
              },
              child: const Text(
                'Add Task',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Task List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskCard(tasks[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      // style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.calendar_today,
            size: 28, color: Colors.blue), // Date icon
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {
            _selectDueDate(context);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            selectedDate != null
                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'Select DDL',
            style: const TextStyle(fontSize: 16, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Widget _buildCategorySelector(BuildContext context) {
    Color categoryColor = selectedCategory != null
        ? getCategoryColor(selectedCategory!)
        : Colors.grey;
    String categoryName = selectedCategory != null
        ? selectedCategory.toString().split('.').last
        : 'Select Category';
    return Row(
      children: <Widget>[
        Icon(Icons.category, size: 28, color: categoryColor), // Category icon
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            _showCategoryDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: categoryColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            categoryName,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Color getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.Personal:
        return Colors.green;
      case TaskCategory.Academic:
        return const Color.fromARGB(255, 16, 177, 210);
      case TaskCategory.Work:
        return Colors.orange;
      case TaskCategory.Other:
        return Colors.purple;
    }
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Select a Category',
            style: TextStyle(
              fontSize: 18, // Adjust the font size
              fontWeight: FontWeight.bold, // Add bold style
              color: Colors.blue, // Change the text color
            ),
          ),
          contentPadding:
              const EdgeInsets.all(10), // Reduce padding inside the AlertDialog
          content: Column(
            children: <Widget>[
              _buildCategoryItem(TaskCategory.Personal,
                  Colors.green), // Assign color to categories
              _buildCategoryItem(TaskCategory.Academic, Colors.blue),
              _buildCategoryItem(TaskCategory.Work, Colors.orange),
              _buildCategoryItem(TaskCategory.Other, Colors.purple),
            ],
          ),
          backgroundColor: Colors.white, // Change the background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Add rounded corners
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(TaskCategory category, Color color) {
    return ListTile(
      title: Text(
        category.toString().split('.').last,
        style:
            TextStyle(color: color), // Set text color based on category color
      ),
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildPrioritySelection() {
    return Row(
      children: <Widget>[
        const Text('Priority:', style: TextStyle(fontSize: 18)),
        // const SizedBox(width: 10),
        _buildPriorityRadioButton(0, 'Low'),
        _buildPriorityRadioButton(1, 'Medium'),
        _buildPriorityRadioButton(2, 'High'),
      ],
    );
  }

  Widget _buildPriorityRadioButton(int value, String label) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: selectedPriority,
          onChanged: (newValue) {
            setState(() {
              selectedPriority = newValue as int;
            });
          },
        ),
        Text(label, style: const TextStyle(fontSize: 14)),
        // const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Description: ${task.description}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Due Date: ${task.dueDate}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Priority: ${getPriorityText(task.priority)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Category: ${task.category}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
