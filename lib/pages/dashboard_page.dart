import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, User!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Your To-Do Lists',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  TaskListCard(
                    listTitle: 'Personal',
                    taskCount: 5,
                  ),
                  TaskListCard(
                    listTitle: 'Work',
                    taskCount: 8,
                  ),
                  // Add more TaskListCard widgets for different lists
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListCard extends StatelessWidget {
  final String listTitle;
  final int taskCount;

  TaskListCard({
    required this.listTitle,
    required this.taskCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(listTitle),
        subtitle: Text('$taskCount tasks'),
        trailing: Icon(Icons.arrow_forward),
      ),
    );
  }
}
