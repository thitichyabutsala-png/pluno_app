import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../shared/extensions/currency_extensions.dart';
import '../../saved_trips/presentation/saved_trips_notifier.dart';
import '../../trips/presentation/providers/trip_providers.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(selectedTripProvider(tripId));

    return Scaffold(
      body: trip.when(
        data: (trip) {
          if (trip == null) {
            return const Center(child: Text('Trip not found.'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar.large(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(trip.title),
                  background: Image.network(trip.coverImage, fit: BoxFit.cover),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Text(
                        trip.destination,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(trip.description),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _Metric(
                              label: 'Budget',
                              value: trip.budget.asBudget,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _Metric(
                              label: 'Duration',
                              value: '${trip.duration} days',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: () => trip.isSaved
                            ? ref
                                .read(savedTripsNotifierProvider.notifier)
                                .unsaveTrip(trip.id)
                            : ref
                                .read(savedTripsNotifierProvider.notifier)
                                .saveTrip(trip),
                        icon: const Icon(Icons.bookmark),
                        label: Text(trip.isSaved ? 'Unsave trip' : 'Save trip'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.goNamed(
                          AppRoute.remixTrip.name,
                          params: {'tripId': trip.id},
                        ),
                        icon: const Icon(Icons.call_split),
                        label: const Text('Remix trip'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
