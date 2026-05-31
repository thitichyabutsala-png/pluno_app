import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../trips/domain/models/trip.dart';
import '../../trips/presentation/providers/trip_providers.dart';

final savedTripsNotifierProvider =
    AsyncNotifierProvider<SavedTripsNotifier, List<Trip>>(
  SavedTripsNotifier.new,
);

class SavedTripsNotifier extends AsyncNotifier<List<Trip>> {
  @override
  Future<List<Trip>> build() async {
    final repository = await ref.watch(tripRepositoryProvider.future);
    return repository.getSavedTrips();
  }

  Future<void> saveTrip(Trip trip) async {
    state = const AsyncLoading<List<Trip>>();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(tripRepositoryProvider.future);
      await repository.saveTrip(trip);
      _invalidateTripReads(trip.id);
      return repository.getSavedTrips();
    });
  }

  Future<void> unsaveTrip(String id) async {
    state = const AsyncLoading<List<Trip>>();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(tripRepositoryProvider.future);
      await repository.unsaveTrip(id);
      _invalidateTripReads(id);
      return repository.getSavedTrips();
    });
  }

  void _invalidateTripReads(String id) {
    ref.invalidate(tripListProvider);
    ref.invalidate(selectedTripProvider(id));
  }
}
