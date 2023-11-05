class Note {
  final String title;
  final String description;
  final String dueDate;
  final int priority;
  final String category;

  Note({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
  });
}

List<Note> sampleNotes = [
  Note(
      title: 'Buy Groceries',
      description: 'Go to keells, buy groceries',
      dueDate: '2024-01-15',
      priority: 1,
      category: 'Home'),
  Note(
      title: 'Study HCI',
      description: 'Studyyyyy',
      dueDate: '2023-11-10',
      priority: 2,
      category: 'Academic'),
];
