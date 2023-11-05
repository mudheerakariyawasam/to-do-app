import 'package:flutter/material.dart';
import '/model/task.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  final List<String> priority =[
    'High',
    'Low',
    'Medium'
  ];
  List<String> selectedPriority = [];
  
  
  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks.where((task) {
      return selectedPriority.isEmpty ||
          selectedPriority.contains(task.priority);
    }).toList(); // Initialize with all tasks
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
              children:priority.map((pty) => FilterChip(
                selected:selectedPriority.contains(pty),
                label:Text(pty), 
                onSelected:(selected){
                  setState(() {
                    if (selected) {
                            selectedPriority.add(pty);
                          } else {
                            selectedPriority.remove(pty);
                          }
                  });
                })).toList() ,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  elevation: 8.0,
                  margin: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Color.fromARGB(255, 227, 233, 255) ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      title: Text(task.title),
                      subtitle: Text(
                      'Priority: ${task.priority}, Label: ${task.label}'),
                ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}