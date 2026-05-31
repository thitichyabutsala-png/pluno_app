import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/trips/data/entities/isar_trip.dart';

class IsarService {
  const IsarService._();

  static Future<Isar> open() async {
    if (Isar.instanceNames.isNotEmpty) {
      return Isar.getInstance()!;
    }

    final directory = await getApplicationDocumentsDirectory();
    return Isar.open(
      [IsarTripSchema],
      directory: directory.path,
      inspector: true,
    );
  }
}
