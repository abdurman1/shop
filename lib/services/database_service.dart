// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference listCollection =
      FirebaseFirestore.instance.collection('lists');

  Future<void> updateUserData(String listName, List<String> items) async {
    return await listCollection.doc(uid).set({
      'listName': listName,
      'items': items,
    }, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot<Object?>> getListStream() {
    return listCollection.doc(uid).snapshots();
  }

  Future<void> addItem(String listName, String item) async {
    return await listCollection.doc(uid).update({
      'items': FieldValue.arrayUnion([item])
    });
  }

  Future<void> removeItem(String listName, String item) async {
    return await listCollection.doc(uid).update({
      'items': FieldValue.arrayRemove([item])
    });
  }
}
