import 'package:flutter/material.dart';

import '../models/trip.dart';
import '../theme/app_colors.dart';
import '../utils/trip_utils.dart';
import '../widgets/common.dart';

const Color _canvas = Color(0xFFF7F6F3);
const Color _field = Color(0xFFF8F7F4);

class RemixPage extends StatelessWidget {
  const RemixPage({this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.background,
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool framed = constraints.maxWidth > 430;
            return Container(
              width: constraints.maxWidth < 430 ? constraints.maxWidth : 430,
              height: framed && constraints.maxHeight > 932
                  ? 932
                  : constraints.maxHeight,
              decoration: BoxDecoration(
                color: _canvas,
                boxShadow: framed
                    ? <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 80,
                          offset: const Offset(0, 24),
                        )
                      ]
                    : null,
              ),
              child: Column(
                children: <Widget>[
                  _RemixHeader(trip: trip),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 28),
                      children: <Widget>[
                        _TripSetupCard(trip: trip),
                        SectionHeaderLine(
                            icon: Icons.access_time,
                            title: 'Itinerary',
                            badge: '${trip.itinerary.length} days'),
                        ...trip.itinerary
                            .map((DayPlan day) => RemixDayCard(day: day)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child:
                              DashedButton(label: 'Add Day', icon: Icons.add),
                        ),
                        SectionHeaderLine(
                            icon: Icons.account_balance_wallet,
                            title: 'Budget Calculator',
                            badge: '${trip.budget} total'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: BudgetMiniEditor(trip: trip),
                        ),
                        SectionHeaderLine(
                            icon: Icons.flight_takeoff,
                            title: 'Transportation'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _TransportCard(destination: trip.destination),
                        ),
                        SectionHeaderLine(
                            icon: Icons.note_alt, title: 'Notes & Reminders'),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: _NotesCard(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RemixHeader extends StatelessWidget {
  const _RemixHeader({this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
      color: _canvas,
      child: Row(
        children: <Widget>[
          CircleButton(
            color: Colors.white,
            icon: Icons.chevron_left,
            iconColor: C.foreground,
            size: 38,
            shadow: Colors.black.withOpacity(0.06),
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('REMIX TRIP',
                    style: TextStyle(
                        color: Color(0xFFA0A0A0),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1)),
                Text(trip.destination,
                    style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF2A9E64), Color(0xFF55B77A)]),
                borderRadius: BorderRadius.circular(99),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.20),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: const <Widget>[
                  Icon(Icons.check, size: 15, color: Colors.white),
                  SizedBox(width: 7),
                  Text('Save Remix',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripSetupCard extends StatelessWidget {
  const _TripSetupCard({this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, 2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: Image.network(trip.image, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Colors.black.withOpacity(0.38),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  child: Row(
                    children: <Widget>[
                      const Text('Remixing from',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      const SizedBox(width: 8),
                      AvatarBubble(trip.creator.avatar, size: 28),
                      const SizedBox(width: 6),
                      Text(trip.creator.handle,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _SoftPill(
                      label: 'Remix',
                      icon: Icons.auto_awesome,
                      color: C.accent,
                      filled: true),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _Label('TRIP NAME'),
                  const SizedBox(height: 8),
                  _InputLike(
                      icon: Icons.edit,
                      text: 'My Maldives Paradise Trip',
                      height: 42),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _DestinationBox(destination: trip.destination),
                      ),
                      const SizedBox(width: 12),
                      const _PeopleStepper(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2)),
          const Spacer(),
          if (badge != null)
            _SoftPill(label: badge, color: C.primary, filled: false),
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
      decoration: BoxDecoration(
        color: C.primary.withOpacity(.07),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: C.primary, shape: BoxShape.circle),
                  child: Text('${day.day}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(day.title,
                        style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 15,
                            fontWeight: FontWeight.w800))),
                Text('${day.activities.length} stops',
                    style: const TextStyle(
                        color: Color(0xFF8C8C8C),
                        fontSize: 11,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          ...day.activities.map((Activity a) => _ActivityEditRow(activity: a)),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 4, 12, 14),
            child: DashedButton(label: 'Add activity', icon: Icons.add),
          ),
        ],
      ),
    );
  }
}

class _ActivityEditRow extends StatelessWidget {
  const _ActivityEditRow({this.activity});
  final Activity activity;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: softCard(radius: 16),
      child: Row(
        children: <Widget>[
          const Icon(Icons.drag_indicator, size: 18, color: Color(0xFFD7D1CB)),
          const SizedBox(width: 8),
          IconBubble(activityIcon(activity.type), activityColor(activity.type),
              size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(activity.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFF1A1A1A),
                              fontSize: 14,
                              height: 1.15,
                              fontWeight: FontWeight.w800)),
                    ),
                    _TypeBadge(activity.type),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    const Icon(Icons.access_time,
                        size: 12, color: Color(0xFF9C9C9C)),
                    const SizedBox(width: 4),
                    Text(activity.time,
                        style: const TextStyle(
                            color: Color(0xFF8C8C8C), fontSize: 12)),
                    const SizedBox(width: 10),
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: Color(0xFF9C9C9C)),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(activity.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFF8C8C8C), fontSize: 12)),
                    ),
                  ],
                ),
                if (activity.notes != null) ...<Widget>[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F1EA),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(activity.notes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xFF7F7B75), fontSize: 12)),
                  ),
                ],
              ],
            ),
          ),
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
    final List<_BudgetLineData> lines = <_BudgetLineData>[
      _BudgetLineData('Accommodation', Icons.hotel, C.blue, 900, 36),
      _BudgetLineData('Food & Dining', Icons.restaurant, C.accent, 600, 24),
      _BudgetLineData('Activities', Icons.terrain, C.primary, 500, 20),
      _BudgetLineData(
          'Transport', Icons.directions_bus, const Color(0xFF6B7FD4), 300, 12),
      _BudgetLineData('Shopping', Icons.shopping_cart, C.purple, 200, 8),
    ];
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _BudgetStat(
                    label: 'TOTAL BUDGET', value: '\$${total.toString()}'),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _BudgetStat(label: 'REMAINING', value: '+\$0'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...lines.map((_) => _BudgetLine(data: _)),
        ],
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  const _TransportCard({this.destination});
  final String destination;
  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _SoftPill(label: 'Flight', color: C.primary, filled: true),
              const SizedBox(width: 8),
              _SoftPill(label: 'Train', color: C.muted, filled: false),
              const SizedBox(width: 8),
              _SoftPill(label: 'Bus', color: C.muted, filled: false),
              const SizedBox(width: 8),
              _SoftPill(label: 'Boat', color: C.muted, filled: false),
            ],
          ),
          const SizedBox(height: 16),
          const _Label('ROUTE DETAILS'),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              const Expanded(
                  child: _InputLike(label: 'FROM', text: 'Origin city')),
              const SizedBox(width: 10),
              Expanded(child: _InputLike(label: 'TO', text: destination)),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Tip: book 6-8 weeks ahead for the best fares',
              style: TextStyle(color: C.muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard();
  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: const <Widget>[
          _NoteChip('🧳 Packing list'),
          _NoteChip('🔑 Booking refs'),
          _NoteChip('💊 Health tips'),
          _NoteChip('📸 Photo spots'),
          _NoteChip('🍜 Must-eats'),
        ],
      ),
    );
  }
}

class _DestinationBox extends StatelessWidget {
  const _DestinationBox({this.destination});
  final String destination;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: C.primary.withOpacity(.22)),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.location_on_outlined, size: 18, color: C.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const _Label('DESTINATION'),
                Text(destination,
                    style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, size: 18, color: C.muted),
        ],
      ),
    );
  }
}

class _PeopleStepper extends StatelessWidget {
  const _PeopleStepper();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration:
          BoxDecoration(color: _field, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: <Widget>[
          const Icon(Icons.group_outlined, color: C.muted, size: 17),
          const SizedBox(width: 8),
          _RoundMini(Icons.remove, C.accent.withOpacity(.16), C.accent),
          const SizedBox(width: 12),
          const Text('2',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
          const SizedBox(width: 12),
          _RoundMini(Icons.add, C.primary.withOpacity(.14), C.primary),
        ],
      ),
    );
  }
}

class _InputLike extends StatelessWidget {
  const _InputLike({this.icon, this.label, this.text, this.height});
  final IconData icon;
  final String label;
  final String text;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration:
          BoxDecoration(color: _field, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 15, color: C.muted),
            const SizedBox(width: 9),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (label != null) ...<Widget>[
                  _Label(label),
                  const SizedBox(height: 2),
                ],
                Text(text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetStat extends StatelessWidget {
  const _BudgetStat({this.label, this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration:
          BoxDecoration(color: _field, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Label(label),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _BudgetLineData {
  const _BudgetLineData(
      this.label, this.icon, this.color, this.amount, this.pct);
  final String label;
  final IconData icon;
  final Color color;
  final int amount;
  final int pct;
}

class _BudgetLine extends StatelessWidget {
  const _BudgetLine({this.data});
  final _BudgetLineData data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          IconBubble(data.icon, data.color, size: 34),
          const SizedBox(width: 10),
          Expanded(
              child: Text(data.label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w800))),
          _RoundMini(Icons.remove, data.color.withOpacity(.10), data.color),
          const SizedBox(width: 8),
          SizedBox(
            width: 58,
            child: Text('\$${data.amount}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
          ),
          _RoundMini(Icons.add, data.color.withOpacity(.10), data.color),
          const SizedBox(width: 10),
          SizedBox(
            width: 34,
            child: Text('${data.pct}%',
                textAlign: TextAlign.right,
                style: const TextStyle(color: C.muted, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge(this.type);
  final String type;
  @override
  Widget build(BuildContext context) {
    final String label = type == 'hotel'
        ? 'Stay'
        : type == 'food'
            ? 'Dining'
            : type == 'coffee'
                ? 'Cafe'
                : type == 'photo'
                    ? 'Photo'
                    : 'Activity';
    final Color color = activityColor(type);
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.11),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

class _SoftPill extends StatelessWidget {
  const _SoftPill({this.label, this.icon, this.color, this.filled});
  final String label;
  final IconData icon;
  final Color color;
  final bool filled;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: icon == null ? 10 : 9, vertical: 6),
      decoration: BoxDecoration(
        color: filled ? color : color.withOpacity(.10),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 12, color: filled ? Colors.white : color),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(
                  color: filled ? Colors.white : color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _RoundMini extends StatelessWidget {
  const _RoundMini(this.icon, this.bg, this.color);
  final IconData icon;
  final Color bg;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: color),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Color(0xFF9D9A95),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2));
  }
}

class _NoteChip extends StatelessWidget {
  const _NoteChip(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration:
          BoxDecoration(color: _field, borderRadius: BorderRadius.circular(99)),
      child: Text(text, style: const TextStyle(color: C.muted, fontSize: 12)),
    );
  }
}
