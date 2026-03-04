import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../domain/entities/event.dart';
import '../models/event_model.dart';

class EventRepository {
  const EventRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  Stream<List<Event>> getEventsForStudent(String studentId) {
    return _firestore
        .collection(FirestoreCollections.events)
        .where('studentIds', arrayContains: studentId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc).toEntity())
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date)),
        );
  }

  Stream<List<Event>> getEventsForVolunteer(String volunteerId) {
    return _firestore
        .collection(FirestoreCollections.events)
        .where('volunteerId', isEqualTo: volunteerId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EventModel.fromFirestore(doc).toEntity())
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date)),
        );
  }

  Future<Event?> getEventById(String eventId) async {
    final doc = await _firestore
        .collection(FirestoreCollections.events)
        .doc(eventId)
        .get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc).toEntity();
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required String type,
    required DateTime date,
    required String volunteerId,
    required List<String> studentIds,
    String? linkedTaskId,
  }) async {
    final batch = _firestore.batch();

    final eventRef = _firestore.collection(FirestoreCollections.events).doc();
    batch.set(eventRef, {
      'title': title,
      'description': description,
      'type': type,
      'date': Timestamp.fromDate(date),
      'volunteerId': volunteerId,
      'studentIds': studentIds,
      'linkedTaskId': linkedTaskId,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (linkedTaskId != null && linkedTaskId.isNotEmpty) {
      final taskRef =
          _firestore.collection(FirestoreCollections.tasks).doc(linkedTaskId);
      batch.update(taskRef, {
        'dueDate': Timestamp.fromDate(date),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }
}
