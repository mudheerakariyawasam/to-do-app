import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/models/task.dart';

void main() {
  runApp(MaterialApp(
    home: TaskListScreen(),
  ));
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NoteSearchDelegate());
            },
          ),
        ],
      ),
      body: NoteListView(),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your search logic and return the results as widgets here
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your search suggestions logic and return the suggestions as widgets here
    return const Center(
      child: Text('Start typing to search'),
    );
  }
}

class NoteListView extends StatefulWidget {
  @override
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  // final List<bool> _completedTasks =
  //     List.generate(sampleNotes.length, (index) => false);
  List<bool> _completedTasks = [];
  List<TaskModel> allTasks = [];

  List<Widget> completedTasksWidgets = [];
  List<Widget> activeTasksWidgets = [];

  String _getPriorityText(int priority) {
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
    debugPrint('getting tasks');
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshot = TaskModel.readAll();

    snapshot.listen((QuerySnapshot<Map<String, dynamic>> snapshot) {
      List<Map<String, dynamic>> documents =
          snapshot.docs.map((document) => document.data()).toList();
      debugPrint('documents: $documents');
      try {
        List<TaskModel> tasks =
            documents.map((document) => TaskModel.fromJson(document)).toList();

        setState(() {
          // if task.isCompleted is true, add true to _completedTasks. otherwise, add false
          _completedTasks = tasks.map((task) => task.isCompleted).toList();
          allTasks = tasks;
        });
      } catch (e) {
        debugPrint('error in getting tasks $e');
      }
    });
  }

  void _editNote(BuildContext context, TaskModel task) {
    // edit task logic
  }

  void _deleteNoteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task?'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Remove the task from the list
                  allTasks.removeAt(index);
                  _completedTasks.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    completedTasksWidgets.clear();
    activeTasksWidgets.clear();
    for (int index = 0; index < allTasks.length; index++) {
      if (_completedTasks[index]) {
        completedTasksWidgets.add(ListTile(
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            allTasks[index].title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey, // Grey out completed tasks
              decoration: TextDecoration.lineThrough,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(allTasks[index].dueDate),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.priority_high,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getPriorityText(allTasks[index].priority),
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.category,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    allTasks[index].category,
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _deleteNoteConfirmation(context, index);
            },
          ),
        ));
      } else {
        activeTasksWidgets.add(ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Checkbox(
            value: _completedTasks[index],
            onChanged: (value) {
              setState(() {
                _completedTasks[index] = value!;
              });
            },
          ),
          title: Text(
            allTasks[index].title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(allTasks[index].dueDate),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.priority_high,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getPriorityText(allTasks[index].priority),
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.category,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    allTasks[index].category,
                    style: const TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              _deleteNoteConfirmation(context, index);
            },
          ),
        ));
      }
    }

    return ListView(
      children: [
        ExpansionTile(
          title: const Text('Completed Tasks'),
          children: completedTasksWidgets,
        ),
        ...activeTasksWidgets,
      ],
    );
  }
}
