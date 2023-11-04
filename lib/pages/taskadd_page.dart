import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: TaskManagementApp(),
//     );
//   }
// }

class TaskManagementApp extends StatefulWidget {
  @override
  _TaskManagementAppState createState() => _TaskManagementAppState();
}

class _TaskManagementAppState extends State<TaskManagementApp> {
  List<Task> tasks = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  int selectedPriority = 0; // Default priority is Low

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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Task Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Task Description',
              ),
            ),
            TextField(
              controller: dueDateController,
              decoration: InputDecoration(
                hintText: 'Due Date',
              ),
            ),
            Row(
              children: <Widget>[
                Text('Priority:'),
                Radio(
                  value: 0,
                  groupValue: selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value as int;
                    });
                  },
                ),
                Text('Low'),
                Radio(
                  value: 1,
                  groupValue: selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value as int;
                    });
                  },
                ),
                Text('Medium'),
                Radio(
                  value: 2,
                  groupValue: selectedPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value as int;
                    });
                  },
                ),
                Text('High'),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                addTask();
              },
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            Text(
              'Task List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index].title),
                    subtitle: Text(
                      'Description: ${tasks[index].description}\nDue Date: ${tasks[index].dueDate}\nPriority: ${getPriorityText(tasks[index].priority)}',
                    ),
                  );
                },
              ),
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
    String dueDate = dueDateController.text;
    int priority = selectedPriority;
    Task newTask = Task(
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
    );
    setState(() {
      tasks.add(newTask);
      titleController.clear();
      descriptionController.clear();
      dueDateController.clear();
      selectedPriority = 0; // Reset priority to Low
    });
  }
}

class Task {
  final String title;
  final String description;
  final String dueDate;
  final int priority;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });
}
