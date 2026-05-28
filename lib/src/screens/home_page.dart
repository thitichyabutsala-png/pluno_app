import 'package:flutter/material.dart';

import '../data/initial_trips.dart';
import '../i18n/translations.dart';
import '../models/trip.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/trip_card.dart';
import 'create_plan_page.dart';
import 'profile_view.dart';
import 'trip_detail_page.dart';

class PlunoHomePage extends StatefulWidget {
  @override
  _PlunoHomePageState createState() => _PlunoHomePageState();
}

class _PlunoHomePageState extends State<PlunoHomePage> {
  List<Trip> trips = initialTrips();
  String tab = 'home';
  String lang = 'en';
  int category = 0;

  T get t => T(lang);

  void toggleSave(Trip trip) {
    setState(() => trip.saved = !trip.saved);
  }

  List<Trip> get displayedTrips {
    final String key = categoryKeys[category];
    final List<Trip> pool = tab == 'saved'
        ? trips.where((Trip trip) => trip.saved).toList()
        : trips.where((Trip trip) {
            if (key == 'All') return true;
            return trip.tags.any(
                    (String tag) => tag.toLowerCase() == key.toLowerCase()) ||
                trip.location.toLowerCase().contains(key.toLowerCase());
          }).toList();
    return pool;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 430),
          color: C.screen,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _Header(
                    t: t,
                    tab: tab,
                    lang: lang,
                    onToggleLang: () {
                      setState(() => lang = lang == 'en' ? 'th' : 'en');
                    },
                  ),
                  if (tab == 'home' || tab == 'discover')
                    _CategoryRail(
                      labels: t.categories,
                      active: category,
                      onTap: (int i) => setState(() => category = i),
                    ),
                  Expanded(
                    child: tab == 'profile'
                        ? ProfileView()
                        : _TripFeed(
                            trips: displayedTrips,
                            t: t,
                            emptyForSaved: tab == 'saved',
                            onSave: toggleSave,
                          ),
                  ),
                ],
              ),
              if (tab == 'home' || tab == 'discover')
                Positioned(
                  right: 20,
                  bottom: 96,
                  child: CircleButton(
                    color: C.primary,
                    size: 56,
                    icon: Icons.add,
                    iconColor: Colors.white,
                    shadow: C.primary.withOpacity(0.50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => CreatePlanPage()),
                    ),
                  ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNav(
                  active: tab,
                  t: t,
                  onTap: (String next) => setState(() => tab = next),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.t, this.tab, this.lang, this.onToggleLang});
  final T t;
  final String tab;
  final String lang;
  final VoidCallback onToggleLang;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 54, 20, 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(t.greeting(tab),
                    style: const TextStyle(
                        color: C.muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
                Text(t.title(tab),
                    style: const TextStyle(
                        color: C.foreground,
                        fontSize: 28,
                        height: 1.1,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggleLang,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(99)),
              child: Row(
                children: <Widget>[
                  _LangPill('EN', lang == 'en'),
                  _LangPill('TH', lang == 'th'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleButton(
            color: C.primary.withOpacity(0.10),
            icon: Icons.search,
            iconColor: C.primary,
            size: 40,
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  const _LangPill(this.label, this.active);
  final String label;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: active ? C.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(99)),
      child: Text(label,
          style: TextStyle(
              color: active ? Colors.white : C.muted,
              fontSize: 12,
              fontWeight: FontWeight.w700)),
    );
  }
}

class _CategoryRail extends StatelessWidget {
  const _CategoryRail({this.labels, this.active, this.onTap});
  final List<String> labels;
  final int active;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(bottom: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (BuildContext context, int i) {
          final bool selected = active == i;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? C.primary : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(labels[i],
                  style: TextStyle(
                      color: selected ? Colors.white : C.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: labels.length,
      ),
    );
  }
}

class _TripFeed extends StatelessWidget {
  const _TripFeed({this.trips, this.t, this.emptyForSaved, this.onSave});
  final List<Trip> trips;
  final T t;
  final bool emptyForSaved;
  final ValueChanged<Trip> onSave;

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 96),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('🗺️', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(t.noTrips,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 5),
            Text(emptyForSaved ? t.startSaving : t.tryCategory,
                style: const TextStyle(color: C.muted, fontSize: 14)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 112),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) => TripCard(
        trip: trips[i],
        t: t,
        onSave: () => onSave(trips[i]),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TripDetailPage(
              trip: trips[i],
              t: t,
              onSave: () => onSave(trips[i]),
            ),
          ),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: trips.length,
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({this.active, this.t, this.onTap});
  final String active;
  final T t;
  final ValueChanged<String> onTap;
  @override
  Widget build(BuildContext context) {
    final List<_NavSpec> specs = <_NavSpec>[
      _NavSpec('home', Icons.home),
      _NavSpec('discover', Icons.explore),
      _NavSpec('saved', Icons.bookmark_border),
      _NavSpec('profile', Icons.person_outline),
    ];
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -4))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: specs.map((_NavSpec spec) {
          final bool selected = active == spec.key;
          return GestureDetector(
            onTap: () => onTap(spec.key),
            child: SizedBox(
              width: 72,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(spec.icon,
                      size: 22, color: selected ? C.primary : C.muted),
                  const SizedBox(height: 4),
                  Text(t.nav(spec.key),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: selected ? C.primary : C.muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavSpec {
  const _NavSpec(this.key, this.icon);
  final String key;
  final IconData icon;
}
