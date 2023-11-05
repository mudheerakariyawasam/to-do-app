class Task {
  final String title;
  final String priority;
  final String label;

  Task({required this.title, required this.priority, required this.label});
}

final List<Task> tasks = [
  Task(title: "Complete HCI Assignment", priority: "High", label: "University"),
  Task(title: "Do Java Tutorial for work", priority: "Medium", label: "Work"),
  Task(title: "Go Grocery Shopping", priority: "Low", label: "Home"),
  // Add more tasks as needed
];