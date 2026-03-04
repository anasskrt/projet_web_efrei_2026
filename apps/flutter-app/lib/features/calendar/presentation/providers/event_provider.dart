import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/providers/firebase_providers.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/repositories/event_repository.dart';
import '../../domain/entities/event.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(firestore: ref.watch(firestoreProvider));
});

final eventsForStudentProvider = StreamProvider<List<Event>>((ref) {
  final userAsync = ref.watch(currentUserModelProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.read(eventRepositoryProvider).getEventsForStudent(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final eventsForVolunteerProvider = StreamProvider<List<Event>>((ref) {
  final userAsync = ref.watch(currentUserModelProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.read(eventRepositoryProvider).getEventsForVolunteer(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final eventsForCurrentUserProvider = StreamProvider<List<Event>>((ref) {
  final userAsync = ref.watch(currentUserModelProvider);
  return userAsync.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      if (user.role == UserRole.volunteer) {
        return ref
            .read(eventRepositoryProvider)
            .getEventsForVolunteer(user.uid);
      }
      return ref.read(eventRepositoryProvider).getEventsForStudent(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final eventDetailProvider =
    FutureProvider.family<Event?, String>((ref, eventId) async {
  return ref.read(eventRepositoryProvider).getEventById(eventId);
});

class CreateEventNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createEvent({
    required String title,
    required String description,
    required String type,
    required DateTime date,
    required String volunteerId,
    required List<String> studentIds,
    String? linkedTaskId,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(eventRepositoryProvider).createEvent(
            title: title,
            description: description,
            type: type,
            date: date,
            volunteerId: volunteerId,
            studentIds: studentIds,
            linkedTaskId: linkedTaskId,
          );
      ref.invalidate(eventsForVolunteerProvider);
      ref.invalidate(eventsForCurrentUserProvider);
    });
  }
}

final createEventNotifierProvider =
    AsyncNotifierProvider<CreateEventNotifier, void>(CreateEventNotifier.new);
