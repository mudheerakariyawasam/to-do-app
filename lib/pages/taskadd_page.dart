import 'package:flutter/material.dart';
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
  String? _selectedImagePath;
  List<Task> tasks = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Add a Task',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildTextField(titleController, 'Task Title'),
            SizedBox(height: 10),
            _buildTextField(descriptionController, 'Task Description'),
            SizedBox(height: 10),
            _buildDateSelector(context),
            SizedBox(height: 10),
            _buildCategorySelector(context),
            SizedBox(height: 10),
            Row(
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addTask();
              },
              child: Text(
                'Add Task',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text(
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
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(Icons.calendar_today, size: 28, color: Colors.blue), // Date icon
        SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {
            _selectDueDate(context);
          },
          child: Text(
            selectedDate != null
                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'Select DDL',
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            side: BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            _showCategoryDialog(context);
          },
          style: ElevatedButton.styleFrom(
            primary: categoryColor,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            categoryName,
            style: TextStyle(fontSize: 16),
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
        return Color.fromARGB(255, 16, 177, 210);
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
          title: Text(
            'Select a Category',
            style: TextStyle(
              fontSize: 18, // Adjust the font size
              fontWeight: FontWeight.bold, // Add bold style
              color: Colors.blue, // Change the text color
            ),
          ),
          contentPadding:
              EdgeInsets.all(10), // Reduce padding inside the AlertDialog
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
        Text('Priority:', style: TextStyle(fontSize: 18)),
        SizedBox(width: 10),
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
        Text(label, style: TextStyle(fontSize: 14)),
        SizedBox(width: 15),
      ],
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Description: ${task.description}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Due Date: ${task.dueDate}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Priority: ${getPriorityText(task.priority)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Category: ${task.category}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

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
    String title = titleController.text;
    String description = descriptionController.text;
    String dueDate = selectedDate != null
        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
        : '';
    int priority = selectedPriority;
    String category = selectedCategory != null
        ? selectedCategory.toString().split('.').last
        : '';
    Task newTask = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      category: category,
    );
    setState(() {
      tasks.add(newTask);
      titleController.clear();
      descriptionController.clear();
      selectedDate = null;
      selectedPriority = 0; // Reset priority to Low
      selectedCategory = null; // Reset category selection
    });
  }
}

class Task {
  final String title;
  final String description;
  final String dueDate;
  final int priority;
  final String category;
  final String? attachmentPath;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.attachmentPath,
  });
}
