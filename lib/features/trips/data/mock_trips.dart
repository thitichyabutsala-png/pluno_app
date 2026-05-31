import '../domain/models/trip.dart';

final mockTrips = <Trip>[
  Trip(
    id: 'maldives-paradise',
    title: 'Maldives Paradise',
    destination: 'Maldives',
    coverImage:
        'https://images.unsplash.com/photo-1603477849227-705c424d1d80?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
    budget: 2500,
    duration: 7,
    description:
        'Overwater bungalows, reef snorkeling, quiet beaches, and sunset dinners across a relaxed island week.',
    createdAt: DateTime(2026, 1, 8),
    updatedAt: DateTime(2026, 1, 8),
  ),
  Trip(
    id: 'swiss-alps-adventure',
    title: 'Alpine Adventure',
    destination: 'Swiss Alps, Switzerland',
    coverImage:
        'https://images.unsplash.com/photo-1589182373726-e4f658ab50f0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
    budget: 3200,
    duration: 10,
    description:
        'A mountain-forward plan through Zurich, Interlaken, scenic rail routes, alpine hikes, and cozy chalet evenings.',
    createdAt: DateTime(2026, 1, 10),
    updatedAt: DateTime(2026, 1, 10),
  ),
  Trip(
    id: 'brussels-city-break',
    title: 'Brussels City Break',
    destination: 'Brussels, Belgium',
    coverImage:
        'https://images.unsplash.com/photo-1668428202528-bf3d5ed88560?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=1080',
    budget: 1800,
    duration: 5,
    description:
        'Grand-Place, chocolate tastings, Art Nouveau stops, craft beer, and easy day trips to Bruges and Ghent.',
    createdAt: DateTime(2026, 1, 12),
    updatedAt: DateTime(2026, 1, 12),
    isSaved: true,
  ),
];
