import 'package:isar/isar.dart';

import '../../domain/models/trip.dart';
import '../entities/isar_trip.dart';
import 'trip_local_data_source.dart';

class IsarTripLocalDataSource implements TripLocalDataSource {
  const IsarTripLocalDataSource(this._isar);

  final Isar _isar;

  @override
  Future<List<Trip>> getTrips() async {
    final trips = await _isar.isarTrips.where().findAll();
    trips.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return trips.map((trip) => trip.toDomain()).toList();
  }

  @override
  Future<List<Trip>> getSavedTrips() async {
    final trips = await getTrips();
    return trips.where((trip) => trip.isSaved).toList();
  }

  @override
  Future<Trip?> getTrip(String id) async {
    final trips = await _isar.isarTrips.where().findAll();
    final matches = trips.where((trip) => trip.tripId == id);
    final trip = matches.isEmpty ? null : matches.first;
    return trip?.toDomain();
  }

  @override
  Future<void> upsertTrip(Trip trip) async {
    await _isar.writeTxn(() async {
      final entity = IsarTrip.fromDomain(trip);
      final trips = await _isar.isarTrips.where().findAll();
      final matches = trips.where((entity) => entity.tripId == trip.id);
      final existing = matches.isEmpty ? null : matches.first;
      if (existing != null) {
        entity.isarId = existing.isarId;
      }
      await _isar.isarTrips.put(entity);
    });
  }

  @override
  Future<void> setSaved(String id, bool isSaved) async {
    await _isar.writeTxn(() async {
      final trips = await _isar.isarTrips.where().findAll();
      final matches = trips.where((trip) => trip.tripId == id);
      if (matches.isEmpty) return;

      final entity = matches.first;
      entity
        ..isSaved = isSaved
        ..updatedAt = DateTime.now();
      await _isar.isarTrips.put(entity);
    });
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _isar.writeTxn(() async {
      final trips = await _isar.isarTrips.where().findAll();
      final matches = trips.where((trip) => trip.tripId == id);
      final trip = matches.isEmpty ? null : matches.first;
      if (trip != null) {
        await _isar.isarTrips.delete(trip.isarId);
      }
    });
  }

  @override
  Future<bool> isEmpty() async {
    return await _isar.isarTrips.count() == 0;
  }
}
