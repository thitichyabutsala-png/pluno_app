import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_frame.dart';
import '../../../shared/widgets/trip_card.dart';
import '../../saved_trips/presentation/saved_trips_notifier.dart';
import '../../trips/domain/models/trip.dart';
import '../../trips/presentation/providers/trip_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.activeRoute = AppRoute.home});

  final AppRoute activeRoute;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _categoryIndex = 0;
  String _language = 'en';

  static const _categories = <String>[
    'All',
    'Beach',
    'Mountain',
    'City',
    'Culture',
    'Adventure',
    'Budget',
  ];

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripListProvider);
    final isThai = _language == 'th';
    final title = widget.activeRoute == AppRoute.discover
        ? (isThai ? 'กำลังฮิต' : 'Trending Now')
        : (isThai ? 'ค้นพบทริป' : 'Discover Trips');

    return AppFrame(
      background: AppColors.screen,
      child: Stack(
        children: [
          Column(
            children: [
              _HomeHeader(
                title: title,
                language: _language,
                onLanguageChanged: () {
                  setState(() => _language = isThai ? 'en' : 'th');
                },
              ),
              _CategoryRail(
                categories: _categories,
                activeIndex: _categoryIndex,
                onSelected: (index) => setState(() => _categoryIndex = index),
              ),
              Expanded(
                child: trips.when(
                  data: (items) {
                    final filteredItems = _filterTrips(items);
                    if (filteredItems.isEmpty) {
                      return _EmptyState(
                        title: isThai ? 'ไม่พบทริป' : 'No trips found',
                        subtitle: isThai
                            ? 'ลองเลือกหมวดหมู่อื่น'
                            : 'Try another category',
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final trip = filteredItems[index];
                        return TripCard(
                          trip: trip,
                          onTap: () => context.goNamed(
                            AppRoute.tripDetail.name,
                            params: {'tripId': trip.id},
                          ),
                          onSave: () => _toggleSaved(trip),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => _ErrorState(message: error.toString()),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNav(
              active: widget.activeRoute,
              onTap: (route) => context.goNamed(route.name),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSaved(Trip trip) {
    final notifier = ref.read(savedTripsNotifierProvider.notifier);
    if (trip.isSaved) {
      notifier.unsaveTrip(trip.id);
    } else {
      notifier.saveTrip(trip);
    }
  }

  List<Trip> _filterTrips(List<Trip> trips) {
    final category = _categories[_categoryIndex];
    if (category == 'All') return trips;

    return trips.where((trip) {
      final haystack = '${trip.title} ${trip.destination} ${trip.description}'
          .toLowerCase();
      switch (category) {
        case 'Beach':
          return haystack.contains('beach') ||
              haystack.contains('maldives') ||
              haystack.contains('thailand') ||
              haystack.contains('island');
        case 'Mountain':
          return haystack.contains('alpine') ||
              haystack.contains('swiss') ||
              haystack.contains('mountain');
        case 'City':
          return haystack.contains('brussels') ||
              haystack.contains('city') ||
              haystack.contains('zurich');
        case 'Culture':
          return haystack.contains('culture') ||
              haystack.contains('museum') ||
              haystack.contains('chocolate');
        case 'Adventure':
          return haystack.contains('adventure') ||
              haystack.contains('hike') ||
              haystack.contains('snorkel');
        case 'Budget':
          return trip.budget <= 1800;
        default:
          return true;
      }
    }).toList();
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.title,
    required this.language,
    required this.onLanguageChanged,
  });

  final String title;
  final String language;
  final VoidCallback onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.foreground,
                fontSize: 28,
                height: 1.1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onLanguageChanged,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                children: [
                  _LanguagePill(label: 'EN', active: language == 'en'),
                  _LanguagePill(label: 'TH', active: language == 'th'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: AppColors.primary, size: 20),
          ),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  const _LanguagePill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.white : AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({
    required this.categories,
    required this.activeIndex,
    required this.onSelected,
  });

  final List<String> categories;
  final int activeIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        itemBuilder: (context, index) {
          final active = activeIndex == index;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    active ? AppColors.primary : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(99),
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index],
                style: TextStyle(
                  color: active ? Colors.white : AppColors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🗺️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load trips.\n$message',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
