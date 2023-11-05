class Task {
  final String title;
  final String priority;
  final String label;

  Task({required this.title, required this.priority, required this.label});
}

final List<Task> tasks = [
  Task(title: "Task 1", priority: "High", label: "Work"),
  Task(title: "Task 2", priority: "Medium", label: "Home"),
  Task(title: "Task 3", priority: "Low", label: "University"),
  // Add more tasks as needed
];