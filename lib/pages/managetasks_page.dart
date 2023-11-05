import 'package:flutter/material.dart';
import '../models/note.dart';

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
        title: Text('Note List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
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
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
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
    return Center(
      child: Text('Start typing to search'),
    );
  }
}

class NoteListView extends StatefulWidget {
  @override
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  List<bool> _completedTasks =
      List.generate(sampleNotes.length, (index) => false);

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

  void _editNote(BuildContext context, Note note) {
    // ... (your existing edit note logic)
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sampleNotes.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Checkbox(
              value: _completedTasks[index],
              onChanged: (value) {
                setState(() {
                  _completedTasks[index] = value!;
                });
              },
            ),
            title: Text(
              sampleNotes[index].title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration:
                    _completedTasks[index] ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(sampleNotes[index].dueDate),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: 16,
                      color: Colors.orange,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${_getPriorityText(sampleNotes[index].priority)}',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      size: 16,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${sampleNotes[index].category}',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {
              _editNote(context, sampleNotes[index]);
            },
          ),
        );
      },
    );
  }
}
