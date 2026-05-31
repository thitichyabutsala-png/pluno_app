import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_frame.dart';
import '../../../shared/widgets/trip_card.dart';
import 'saved_trips_notifier.dart';

class SavedTripsScreen extends ConsumerWidget {
  const SavedTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedTrips = ref.watch(savedTripsNotifierProvider);

    return AppFrame(
      background: AppColors.screen,
      child: Stack(
        children: [
          Column(
            children: [
              const _SavedHeader(),
              Expanded(
                child: savedTrips.when(
                  data: (trips) {
                    if (trips.isEmpty) {
                      return const _SavedEmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
                      physics: const BouncingScrollPhysics(),
                      itemCount: trips.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return TripCard(
                          trip: trip,
                          onTap: () => context.goNamed(
                            AppRoute.tripDetail.name,
                            params: {'tripId': trip.id},
                          ),
                          onSave: () => ref
                              .read(savedTripsNotifierProvider.notifier)
                              .unsaveTrip(trip.id),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => _SavedErrorState(message: error.toString()),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNav(
              active: AppRoute.savedTrips,
              onTap: (route) => context.goNamed(route.name),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavedHeader extends StatelessWidget {
  const _SavedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Saved Trips',
              style: TextStyle(
                color: AppColors.foreground,
                fontSize: 28,
                height: 1.1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.active, required this.onTap});

  final AppRoute active;
  final ValueChanged<AppRoute> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _NavItem(
            icon: Icons.home,
            label: 'Home',
            selected: active == AppRoute.home,
            onTap: () => onTap(AppRoute.home),
          ),
          _NavItem(
            icon: Icons.explore,
            label: 'Discover',
            selected: active == AppRoute.discover,
            onTap: () => onTap(AppRoute.discover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () => onTap(AppRoute.createTrip),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.50),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
          _NavItem(
            icon: Icons.bookmark_border,
            label: 'Saved',
            selected: active == AppRoute.savedTrips,
            onTap: () => onTap(AppRoute.savedTrips),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            selected: active == AppRoute.profile,
            onTap: () => onTap(AppRoute.profile),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.muted;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedEmptyState extends StatelessWidget {
  const _SavedEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('🗺️', style: TextStyle(fontSize: 40)),
          SizedBox(height: 10),
          Text(
            'No trips found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 5),
          Text(
            'Start saving trips you love',
            style: TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _SavedErrorState extends StatelessWidget {
  const _SavedErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load saved trips.\n$message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
