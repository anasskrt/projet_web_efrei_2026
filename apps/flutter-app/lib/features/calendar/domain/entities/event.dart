enum EventType {
  cours,
  reunion,
  deadline;

  String get value => switch (this) {
        EventType.cours => 'cours',
        EventType.reunion => 'reunion',
        EventType.deadline => 'deadline',
      };

  static EventType fromString(String value) {
    return EventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => EventType.cours,
    );
  }
}

class Event {
  const Event({
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
  final EventType type;
  final DateTime date;
  final String volunteerId;
  final List<String> studentIds;
  final String? linkedTaskId;
  final DateTime createdAt;
}
