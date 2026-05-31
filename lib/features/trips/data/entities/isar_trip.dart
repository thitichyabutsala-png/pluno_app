import 'package:isar/isar.dart';

import '../../domain/models/trip.dart';

part 'isar_trip.g.dart';

@collection
class IsarTrip {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String tripId;

  late String title;
  late String destination;
  late String coverImage;
  late double budget;
  late int duration;
  late String description;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isSaved;

  Trip toDomain() {
    return Trip(
      id: tripId,
      title: title,
      destination: destination,
      coverImage: coverImage,
      budget: budget,
      duration: duration,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSaved: isSaved,
    );
  }

  static IsarTrip fromDomain(Trip trip) {
    return IsarTrip()
      ..tripId = trip.id
      ..title = trip.title
      ..destination = trip.destination
      ..coverImage = trip.coverImage
      ..budget = trip.budget
      ..duration = trip.duration
      ..description = trip.description
      ..createdAt = trip.createdAt
      ..updatedAt = trip.updatedAt
      ..isSaved = trip.isSaved;
  }
}
