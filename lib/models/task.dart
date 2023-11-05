import 'package:to_do_app/services/database_service.dart';

class TaskModel {
  String userId = '';
  String title;
  String description;
  List<String> tags = [];
  int priority;
  String dueDate;
  String dueTime ='';
  bool isCompleted = false;
  bool isReminderSet = false;

  static const String collection = 'tasks';
  static final DatabaseService _db = DatabaseService();

  TaskModel({
    required this.title,
    required this.description,
    required this.tags,
    required this.priority,
    required this.dueDate,
    required this.dueTime,
    required this.isCompleted,
  });

  TaskModel.forTest({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        tags = json['tags'].cast<String>(),
        priority = json['priority'],
        dueDate = json['date'],
        dueTime = json['time'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'tags': tags,
        'date': dueDate,
        'time': dueTime,
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
  static Stream<List<TaskModel>> read() {
    return _db.read(collection).map((snapshot) => snapshot.docs
        .map((document) => TaskModel.fromJson(document.data()))
        .toList());
  }

  // get task by id from database
  Stream<TaskModel> readById(String id) {
    return _db.readById(collection, id).map((snapshot) =>
        TaskModel.fromJson(snapshot.data() as Map<String, dynamic>));
  }


}