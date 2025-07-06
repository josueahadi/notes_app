import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app/data/models/note_model.dart';
import 'package:notes_app/domain/entities/note.dart';

class NotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  CollectionReference get _notesCollection =>
      _firestore.collection('users').doc(_userId).collection('notes');

  Future<List<Note>> fetchNotes() async {
    try {
      final snapshot = await _notesCollection
          .orderBy('updatedAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch notes: $e';
    }
  }

  Future<void> addNote(String text) async {
    try {
      final now = DateTime.now();
      final noteModel = NoteModel(
        id: '',
        text: text,
        createdAt: now,
        updatedAt: now,
      );
      
      await _notesCollection.add(noteModel.toFirestore());
    } catch (e) {
      throw 'Failed to add note: $e';
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await _notesCollection.doc(id).update({
        'text': text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw 'Failed to update note: $e';
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _notesCollection.doc(id).delete();
    } catch (e) {
      throw 'Failed to delete note: $e';
    }
  }
}
