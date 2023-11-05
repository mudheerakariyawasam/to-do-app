import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/pages/managetasks_page.dart';
import 'package:to_do_app/services/notification_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  String? _selectedImagePath;

  Future<void> _selectAttachment(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

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

  void addTask() {
    debugPrint('adding task');
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

      try {
        // schedule notification if selected date is in the future
        DateTime today = DateTime.now();
        if (selectedDate != null && selectedDate!.isAfter(today)) {
          // schedule notification to be sent on the selected date at 6am
          DateTime scheduleTime = DateTime(selectedDate!.year,
              selectedDate!.month, selectedDate!.day, 6, 0, 0);

          NotificationService().scheduleNotification(
              title: title,
              body: description,
              scheduledNotificationDateTime: scheduleTime);
        } else {
          NotificationService()
              .showNotification(title: title, body: description);
        }
      } catch (e) {
        debugPrint('error in scheduling notification $e');
      }
      setState(() {
        titleController.clear();
        descriptionController.clear();
        selectedDate = null;
        selectedPriority = 0;
        selectedCategory = null;
      });
    } catch (e) {
      debugPrint('error in saving $e');
    }
  }

  @override
  void initState() {
    super.initState();
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
            const SizedBox(height: 10),
            const Row(
              children: <Widget>[
                Icon(Icons.attach_file,
                    size: 28, color: Colors.blue), // Attachment icon
                SizedBox(width: 10),
              ],
            ),
            _selectedImagePath != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.file(
                      File(_selectedImagePath!),
                      height: 100,
                    ),
                  )
                : Container(),
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
            ElevatedButton(
              onPressed: () {
                // Navigate to view tasks page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskListScreen(),
                  ),
                );
              },
              child: const Text(
                'View Tasks',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            // const Text(
            //   'Task List',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
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
              const SizedBox(height: 16), // Add some spacing
              ElevatedButton(
                onPressed: () {
                  _showCreateLabelDialog(context);
                },
                child: const Text('Create Label'), // Button text
              ),
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

  void _showCreateLabelDialog(BuildContext context) {
    String labelName = '';
    Color selectedColor = Colors.red;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Label Name'),
                onChanged: (value) {
                  labelName = value;
                },
              ),
              const SizedBox(height: 16),
              const Text('Select Label Color:'),
              ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (color) {
                  selectedColor = color;
                },
                colorPickerWidth: 300.0,
                pickerAreaHeightPercent: 0.7,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle label creation logic here
                  debugPrint('Label Name: $labelName, Color: $selectedColor');
                  Navigator.of(context).pop();
                },
                child: const Text('Create'),
              ),
            ],
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
