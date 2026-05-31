import '../models/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrips();
  Future<List<Trip>> getSavedTrips();
  Future<Trip?> getTrip(String id);
  Future<void> saveTrip(Trip trip);
  Future<void> unsaveTrip(String id);
  Future<void> deleteTrip(String id);
}
