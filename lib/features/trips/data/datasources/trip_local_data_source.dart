import '../../domain/models/trip.dart';

abstract class TripLocalDataSource {
  Future<List<Trip>> getTrips();
  Future<List<Trip>> getSavedTrips();
  Future<Trip?> getTrip(String id);
  Future<void> upsertTrip(Trip trip);
  Future<void> setSaved(String id, bool isSaved);
  Future<void> deleteTrip(String id);
  Future<bool> isEmpty();
}
