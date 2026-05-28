import 'package:flutter/material.dart';

import '../i18n/translations.dart';
import '../models/trip.dart';
import '../theme/app_colors.dart';
import '../utils/trip_utils.dart';
import '../widgets/common.dart';
import 'remix_page.dart';

class TripDetailPage extends StatefulWidget {
  const TripDetailPage({this.trip, this.t, this.onSave});
  final Trip trip;
  final T t;
  final VoidCallback onSave;

  @override
  _TripDetailPageState createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  String active = 'itinerary';

  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;
    final T t = widget.t;
    return Scaffold(
      backgroundColor: C.softScreen,
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.only(bottom: 108),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              _DetailHero(trip: trip, onBack: () => Navigator.pop(context), onSave: () {
                setState(widget.onSave);
              }),
              Transform.translate(
                offset: const Offset(0, -24),
                child: Container(
                  decoration: const BoxDecoration(
                    color: C.softScreen,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: <Widget>[
                      _DetailMeta(trip: trip, t: t),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                        child: Row(
                          children: <Widget>[
                            TabButton(t.itinerary, active == 'itinerary',
                                () => setState(() => active = 'itinerary')),
                            const SizedBox(width: 8),
                            TabButton(t.budget, active == 'budget',
                                () => setState(() => active = 'budget')),
                            const SizedBox(width: 8),
                            TabButton(t.places, active == 'places',
                                () => setState(() => active = 'places')),
                          ],
                        ),
                      ),
                      if (active == 'itinerary')
                        ItineraryTab(trip: trip, dayLabel: t.day),
                      if (active == 'budget') BudgetTab(trip: trip),
                      if (active == 'places') PlacesTab(trip: trip),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ActionButton(
                    label: trip.saved ? t.saved : t.saveTrip,
                    icon: trip.saved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                    textColor: trip.saved ? C.primary : C.muted,
                    borderColor: trip.saved ? C.primary : C.line,
                    onTap: () => setState(widget.onSave),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    label: t.remixTrip,
                    icon: Icons.call_split,
                    color: C.accent,
                    textColor: Colors.white,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            RemixPage(trip: trip),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHero extends StatelessWidget {
  const _DetailHero({this.trip, this.onBack, this.onSave});
  final Trip trip;
  final VoidCallback onBack;
  final VoidCallback onSave;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(trip.image, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withOpacity(0.28),
                  Colors.transparent,
                  Colors.black.withOpacity(0.55)
                ],
              ),
            ),
          ),
          Positioned(
            top: 52,
            left: 16,
            child: CircleButton(
                color: Colors.white.withOpacity(0.88),
                icon: Icons.chevron_left,
                iconColor: C.foreground,
                size: 40,
                onTap: onBack),
          ),
          Positioned(
            top: 52,
            right: 16,
            child: Row(
              children: <Widget>[
                CircleButton(
                    color: Colors.white.withOpacity(0.88),
                    icon: Icons.share,
                    iconColor: C.foreground,
                    size: 40),
                const SizedBox(width: 8),
                CircleButton(
                    color: Colors.white.withOpacity(0.88),
                    icon: trip.saved ? Icons.bookmark : Icons.bookmark_border,
                    iconColor: trip.saved ? C.primary : C.foreground,
                    size: 40,
                    onTap: onSave),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 44,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: trip.tags
                      .map((String tag) => FrostTag(label: tag))
                      .toList(),
                ),
                const SizedBox(height: 8),
                Text(trip.destination,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.15,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                IconText(Icons.location_on, trip.location,
                    color: Colors.white70, textColor: Colors.white70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailMeta extends StatelessWidget {
  const _DetailMeta({this.trip, this.t});
  final Trip trip;
  final T t;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: C.line)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AvatarBubble(trip.creator.avatar, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(trip.creator.name,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    Text(trip.creator.handle,
                        style: const TextStyle(color: C.muted, fontSize: 12)),
                  ],
                ),
              ),
              TinyStat(Icons.bookmark_border, formatSaves(trip.saves)),
              const SizedBox(width: 12),
              TinyStat(Icons.call_split, trip.remixes.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: C.line),
            ),
            child: Row(
              children: <Widget>[
                MetaCell(Icons.access_time, trip.duration, t.duration),
                MetaCell(Icons.attach_money, trip.budget, t.budget),
                MetaCell(Icons.people, '2 ${t.people}', t.travelers,
                    last: true),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(trip.description,
              style: const TextStyle(
                  color: Color(0xFF6A6A6A), fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}

class ItineraryTab extends StatelessWidget {
  const ItineraryTab({this.trip, this.dayLabel});
  final Trip trip;
  final String dayLabel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: trip.itinerary.map((DayPlan day) {
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: <Color>[C.primary, C.secondary]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(day.day.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('$dayLabel ${day.day}'.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8)),
                        Text(day.title,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Column(
                children: day.activities
                    .map((Activity act) => ActivityRow(activity: act))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Divider(color: C.line),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ActivityRow extends StatelessWidget {
  const ActivityRow({this.activity});
  final Activity activity;
  @override
  Widget build(BuildContext context) {
    final Color color = activityColor(activity.type);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 54,
          child: Column(
            children: <Widget>[
              Text(activity.time,
                  style: const TextStyle(
                      color: Colors.black38,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: color.withOpacity(0.20),
                          spreadRadius: 4,
                          blurRadius: 0)
                    ]),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: softCard(radius: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconBubble(activityIcon(activity.type), color),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(activity.title,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      IconText(Icons.location_on, activity.location,
                          color: Colors.black26, textColor: Colors.black38),
                      if (activity.notes != null) ...<Widget>[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF8F7F5),
                              borderRadius: BorderRadius.circular(12)),
                          child: Text('💡 ${activity.notes}',
                              style: const TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 12,
                                  height: 1.4)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BudgetTab extends StatelessWidget {
  const BudgetTab({this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    final int total = parseBudget(trip.budget);
    final List<_BudgetItem> items = <_BudgetItem>[
      _BudgetItem('Accommodation', Icons.hotel, C.blue, .36),
      _BudgetItem('Food & Dining', Icons.restaurant, C.accent, .24),
      _BudgetItem('Activities', Icons.terrain, C.primary, .20),
      _BudgetItem('Transport', Icons.directions_bus, const Color(0xFF6B7FD4), .12),
      _BudgetItem('Shopping', Icons.shopping_cart, C.purple, .08),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: <Color>[Color(0xFF1F6B45), C.primary, C.secondary]),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('TOTAL ESTIMATED BUDGET',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8)),
                const SizedBox(height: 6),
                Text(trip.budget,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w800)),
                Text('≈ \$${(total / 2).round()} per person · ${trip.duration}',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: softCard(radius: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Breakdown',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 14),
                Column(
                  children: items.map((item) {
                    final int amount = (total * item.pct).round();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              IconBubble(item.icon, item.color, size: 28),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(item.label,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500))),
                              Text('${(item.pct * 100).round()}%',
                                  style: const TextStyle(
                                      color: Colors.black38, fontSize: 12)),
                              const SizedBox(width: 8),
                              Text('\$${amount.toString()}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: item.pct,
                            backgroundColor: C.line,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlacesTab extends StatelessWidget {
  const PlacesTab({this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MapPreview(location: trip.location),
          const SizedBox(height: 16),
          const Text('Recommended Spots',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: trip.places
                .map((Place place) => PlaceCard(place: place))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text('Local Tips',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Column(
            children: trip.tips
                .map((String tip) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: softCard(radius: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('💡'),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(tip,
                                  style: const TextStyle(
                                      color: Color(0xFF5A5A5A),
                                      fontSize: 13,
                                      height: 1.45))),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class MapPreview extends StatelessWidget {
  const MapPreview({this.location});
  final String location;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: <Color>[Color(0xFFC8DFCA), Color(0xFFB4CEC4), Color(0xFFC2D5CE)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 14,
            left: 14,
            child: InfoChip(Icons.location_on, location,
                color: C.foreground, bg: Colors.white.withOpacity(.92)),
          ),
          const Positioned(
              left: 80,
              top: 70,
              child: Icon(Icons.location_on, color: C.primary, size: 36)),
          Positioned(
            right: 14,
            bottom: 14,
            child: InfoChip(Icons.navigation, 'Open Map',
                color: Colors.white, bg: C.primary),
          ),
        ],
      ),
    );
  }
}

class PlaceCard extends StatelessWidget {
  const PlaceCard({this.place});
  final Place place;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 184,
      child: Container(
        decoration: softCard(radius: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 64,
              alignment: Alignment.center,
              color: C.primary.withOpacity(.12),
              child: const Icon(Icons.location_on, color: C.primary, size: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(place.name,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(place.type,
                      style: const TextStyle(color: Colors.black38, fontSize: 11)),
                  const SizedBox(height: 6),
                  Text('★ ${place.rating}',
                      style: const TextStyle(
                          color: C.accent,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(place.tip,
                      style: const TextStyle(
                          color: Color(0xFF8A8A8A),
                          fontSize: 12,
                          height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetItem {
  const _BudgetItem(this.label, this.icon, this.color, this.pct);
  final String label;
  final IconData icon;
  final Color color;
  final double pct;
}
