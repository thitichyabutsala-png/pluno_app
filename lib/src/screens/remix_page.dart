import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../theme/app_colors.dart';
import '../utils/trip_utils.dart';
import '../widgets/common.dart';

class RemixPage extends StatelessWidget {
  const RemixPage({this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 52, 16, 12),
            child: Row(
              children: <Widget>[
                CircleButton(
                    color: Colors.white,
                    icon: Icons.chevron_left,
                    iconColor: C.foreground,
                    size: 36,
                    onTap: () => Navigator.pop(context)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('My ${trip.destination} Trip',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800)),
                      Text('Remix from ${trip.creator.handle}',
                          style:
                              const TextStyle(color: C.muted, fontSize: 12)),
                    ],
                  ),
                ),
                ActionChipButton(
                  label: 'Save',
                  icon: Icons.check,
                  enabled: true,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 28),
              children: <Widget>[
                SectionHeaderLine(icon: Icons.map, title: 'Destination'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        IconBubble(Icons.public, C.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(trip.location,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                        const Icon(Icons.edit, size: 16, color: C.muted),
                      ],
                    ),
                  ),
                ),
                SectionHeaderLine(
                    icon: Icons.format_align_left,
                    title: 'Itinerary',
                    badge: '${trip.itinerary.length} days'),
                ...trip.itinerary.map((DayPlan day) => RemixDayCard(day: day)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DashedButton(label: 'Add day', icon: Icons.add),
                ),
                SectionHeaderLine(icon: Icons.account_balance_wallet, title: 'Budget'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BudgetMiniEditor(trip: trip),
                ),
                SectionHeaderLine(icon: Icons.flight, title: 'Transport'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        IconBubble(Icons.flight, const Color(0xFF6B7FD4)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text('Origin city  →  Destination',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
                SectionHeaderLine(icon: Icons.note, title: 'Notes'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FCard(
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      '🧳 Packing list   🔑 Booking refs   📸 Photo spots',
                      style: TextStyle(color: C.muted, fontSize: 13),
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

class SectionHeaderLine extends StatelessWidget {
  const SectionHeaderLine({this.icon, this.title, this.badge});
  final IconData icon;
  final String title;
  final String badge;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 14, color: Colors.black38),
          const SizedBox(width: 8),
          Text(title.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .9)),
          const Spacer(),
          if (badge != null) InfoChip(Icons.check, badge, color: C.primary),
        ],
      ),
    );
  }
}

class RemixDayCard extends StatelessWidget {
  const RemixDayCard({this.day});
  final DayPlan day;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: C.primary.withOpacity(.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconBubble(Icons.calendar_today, C.primary, size: 32),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(day.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700))),
              Text('${day.activities.length} stops',
                  style: const TextStyle(color: C.muted, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          ...day.activities.map((Activity a) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: softCard(radius: 16),
                child: Row(
                  children: <Widget>[
                    IconBubble(activityIcon(a.type), activityColor(a.type),
                        size: 32),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(a.title,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700)),
                          Text('${a.time} · ${a.location}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.black38, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          DashedButton(label: 'Add activity', icon: Icons.add),
        ],
      ),
    );
  }
}

class BudgetMiniEditor extends StatelessWidget {
  const BudgetMiniEditor({this.trip});
  final Trip trip;
  @override
  Widget build(BuildContext context) {
    final int total = parseBudget(trip.budget);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: <Color>[Color(0xFF1F6B45), C.primary]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Total Budget',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text('\$${total.toString()}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}
