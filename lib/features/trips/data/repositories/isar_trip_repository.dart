import '../../domain/models/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/trip_local_data_source.dart';

class IsarTripRepository implements TripRepository {
  const IsarTripRepository(this._localDataSource);

  final TripLocalDataSource _localDataSource;

  @override
  Future<List<Trip>> getTrips() => _localDataSource.getTrips();

  @override
  Future<List<Trip>> getSavedTrips() => _localDataSource.getSavedTrips();

  @override
  Future<Trip?> getTrip(String id) => _localDataSource.getTrip(id);

  @override
  Future<void> saveTrip(Trip trip) {
    return _localDataSource.upsertTrip(
      trip.copyWith(updatedAt: DateTime.now(), isSaved: true),
    );
  }

  @override
  Future<void> unsaveTrip(String id) => _localDataSource.setSaved(id, false);

  @override
  Future<void> deleteTrip(String id) => _localDataSource.deleteTrip(id);
}
