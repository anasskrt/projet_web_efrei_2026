import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/event.dart';

class EventModel {
  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    required this.volunteerId,
    required this.studentIds,
    this.linkedTaskId,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String type;
  final DateTime date;
  final String volunteerId;
  final List<String> studentIds;
  final String? linkedTaskId;
  final DateTime createdAt;

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String? ?? '',
      type: data['type'] as String,
      date: (data['date'] as Timestamp).toDate(),
      volunteerId: data['volunteerId'] as String,
      studentIds: List<String>.from(data['studentIds'] as List? ?? []),
      linkedTaskId: data['linkedTaskId'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Event toEntity() => Event(
        id: id,
        title: title,
        description: description,
        type: EventType.fromString(type),
        date: date,
        volunteerId: volunteerId,
        studentIds: studentIds,
        linkedTaskId: linkedTaskId,
        createdAt: createdAt,
      );
}
