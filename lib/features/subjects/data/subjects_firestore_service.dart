import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_tap/core/models/subject_model.dart';

class SubjectsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _subjectsCollection() {
    final uid = _auth.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No logged-in user found.',
      );
    }

    return _firestore.collection('users').doc(uid).collection('subjects');
  }

  Future<List<SubjectModel>> fetchSubjects() async {
    final snapshot = await _subjectsCollection().orderBy('title').get();

    return snapshot.docs
        .map((doc) => SubjectModel.fromMap(doc.data(), id: doc.id))
        .toList();
  }

  Future<SubjectModel> addSubject(SubjectModel subject) async {
    final docRef = await _subjectsCollection().add(subject.toMap());
    return subject.copyWith(id: docRef.id);
  }

  Future<void> updateSubject(SubjectModel subject) async {
    final id = subject.id;
    if (id == null || id.isEmpty) return;

    await _subjectsCollection().doc(id).update(subject.toMap());
  }

  Future<void> deleteSubject(String subjectId) async {
    if (subjectId.isEmpty) return;
    await _subjectsCollection().doc(subjectId).delete();
  }
}
