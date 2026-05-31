import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/create_trip/presentation/create_trip_screen.dart';
import '../../features/create_trip/presentation/edit_trip_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/remix_trip/presentation/remix_trip_screen.dart';
import '../../features/saved_trips/presentation/saved_trips_screen.dart';
import '../../features/trip_detail/presentation/trip_detail_screen.dart';

enum AppRoute {
  home,
  discover,
  tripDetail,
  createTrip,
  editTrip,
  savedTrips,
  remixTrip,
  profile,
}

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/discover',
      name: AppRoute.discover.name,
      builder: (context, state) =>
          const HomeScreen(activeRoute: AppRoute.discover),
    ),
    GoRoute(
      path: '/trips/:tripId',
      name: AppRoute.tripDetail.name,
      builder: (context, state) => TripDetailScreen(
        tripId: state.params['tripId']!,
      ),
    ),
    GoRoute(
      path: '/trips/:tripId/edit',
      name: AppRoute.editTrip.name,
      builder: (context, state) => EditTripScreen(
        tripId: state.params['tripId']!,
      ),
    ),
    GoRoute(
      path: '/trips/:tripId/remix',
      name: AppRoute.remixTrip.name,
      builder: (context, state) => RemixTripScreen(
        tripId: state.params['tripId']!,
      ),
    ),
    GoRoute(
      path: '/create',
      name: AppRoute.createTrip.name,
      builder: (context, state) => const CreateTripScreen(),
    ),
    GoRoute(
      path: '/saved',
      name: AppRoute.savedTrips.name,
      builder: (context, state) => const SavedTripsScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: AppRoute.profile.name,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Route not found')),
    body: Center(child: Text(state.error.toString())),
  ),
);
