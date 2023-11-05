import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> create(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  Future<void> update(String collection, String id, Map<String, dynamic> data) async {
    await _db.collection(collection).doc(id).update(data);
  }

  Future<void> delete(String collection, String id) async {
    await _db.collection(collection).doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAll(String collection) {
    return _db.collection(collection).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readByQuery(String collection, String field, String value) {
    return _db.collection(collection).where(field, isEqualTo: value).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> readById(String collection, String id) {
    return _db.collection(collection).doc(id).snapshots();
  }
}