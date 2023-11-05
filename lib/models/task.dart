import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/services/database_service.dart';

class TaskModel {
  String userId = '';
  String id = '';
  String title;
  String description;
  List<String> tags = [];
  String category = '';
  int priority;
  String dueDate;
  bool isCompleted = false;
  bool isReminderSet = false;

  static const String collection = 'tasks';
  static final DatabaseService _db = DatabaseService();

  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
    required this.priority,
    required this.isCompleted,
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        dueDate = json['dueDate'],
        category = json['category'],
        priority = json['priority'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'category': category,
        'priority': priority,
        'isCompleted': isCompleted,
      };

  // save task in database
  Future<void> save() async {
    await _db.create(collection, toJson());
  }

  // update task in database
  Future<void> update(String id) async {
    await _db.update(collection, id, toJson());
  }

  // delete task in database
  Future<void> delete(String id) async {
    await _db.delete(collection, id);
  }

  // get all tasks from database
  static Stream<QuerySnapshot<Map<String, dynamic>>> readAll() {
    return _db.readAll(collection);
  }

  // get task by id from database
  Stream<TaskModel> readById(String id) {
    return _db.readById(collection, id).map((snapshot) =>
        TaskModel.fromJson(snapshot.data() as Map<String, dynamic>));
  }

  // mark task as completed in database
  Future<void> markAsCompleted(String id) async {
    await _db.update(collection, id, {'isCompleted': true});
  }
}
