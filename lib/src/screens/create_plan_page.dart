import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/trip_utils.dart';
import '../widgets/common.dart';

class CreatePlanPage extends StatefulWidget {
  @override
  _CreatePlanPageState createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  String destination = '';
  String transport = 'Flight';
  String budget = 'Comfort';
  String privacy = 'Public';
  bool aiShown = false;
  final List<String> selectedActivities = <String>[];

  @override
  Widget build(BuildContext context) {
    final bool canCreate = destination.isNotEmpty;
    return Scaffold(
      backgroundColor: C.createBg,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 54, 20, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleButton(
                    color: C.primary.withOpacity(0.10),
                    icon: Icons.close,
                    iconColor: C.primary,
                    size: 36,
                    onTap: () => Navigator.pop(context)),
                Column(
                  children: const <Widget>[
                    Text('New Trip',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text('Plan your adventure',
                        style: TextStyle(
                            color: C.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                ActionChipButton(
                  label: 'Create',
                  icon: Icons.add,
                  enabled: canCreate,
                  onTap: canCreate ? () => Navigator.pop(context) : null,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                CoverPicker(),
                SectionLabel('Where to?'),
                FCard(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: <Widget>[
                            IconBubble(Icons.location_on, C.primary, size: 36),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                onChanged: (String v) =>
                                    setState(() => destination = v),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search destination...'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: Color(0xFFE8F5EF)),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: <String>[
                            '🏝️ Maldives',
                            '🏔️ Swiss Alps',
                            '⛩️ Kyoto',
                            '🏛️ Santorini',
                            '🌺 Bali',
                            '🗼 Paris',
                            '🗽 New York',
                            '🍋 Amalfi'
                          ].map((String item) {
                            final String label = item.substring(3);
                            final bool active = destination == label;
                            return ChoicePill(
                              label: item,
                              active: active,
                              onTap: () =>
                                  setState(() => destination = label),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SectionLabel('When?'),
                FCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: DateBox(label: 'From', value: 'Jun 8')),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: IconBubble(Icons.chevron_right, C.primary),
                      ),
                      Expanded(child: DateBox(label: 'To', value: 'Jun 15')),
                    ],
                  ),
                ),
                SectionLabel('What\'s the vibe?'),
                FCard(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <String>[
                      'Beach',
                      'Hiking',
                      'Food Tour',
                      'Culture',
                      'Shopping',
                      'Nightlife',
                      'Arts',
                      'Adventure',
                      'Wellness',
                      'Photography'
                    ].map((String label) {
                      final bool active = selectedActivities.contains(label);
                      return ChoicePill(
                        label: label,
                        active: active,
                        color: tagColor(label),
                        onTap: () => setState(() {
                          active
                              ? selectedActivities.remove(label)
                              : selectedActivities.add(label);
                        }),
                      );
                    }).toList(),
                  ),
                ),
                SectionLabel('Getting there'),
                PickerRow(
                  values: <String>['Flight', 'Train', 'Bus', 'Drive', 'Boat'],
                  active: transport,
                  onTap: (String v) => setState(() => transport = v),
                ),
                SectionLabel('Budget'),
                PickerGrid(
                  values: <String>['🎒 Economy\nUnder \$1k', '🏨 Comfort\n\$1k-\$3k', '✈️ Premium\n\$3k-\$8k', '💎 Luxury\n\$8k+'],
                  activeStartsWith: budget,
                  onTap: (String v) =>
                      setState(() => budget = v.split('\n').first.substring(3)),
                ),
                SectionLabel('Who can see this?'),
                PickerRow(
                  values: <String>['Public', 'Friends', 'Private'],
                  active: privacy,
                  onTap: (String v) => setState(() => privacy = v),
                ),
                SectionLabel('AI Trip Planner ✨'),
                AiPlanner(
                  destination: destination,
                  shown: aiShown,
                  onTap: () => setState(() => aiShown = true),
                ),
                const SizedBox(height: 18),
                ActionButton(
                  label: canCreate ? 'Create Trip' : 'Create Trip',
                  icon: Icons.star,
                  color: canCreate ? C.primary : Colors.black12,
                  textColor: canCreate ? Colors.white : Colors.black38,
                  onTap: canCreate ? () => Navigator.pop(context) : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChoicePill extends StatelessWidget {
  const ChoicePill({this.label, this.active, this.onTap, this.color});
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final Color c = color ?? C.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? c : c.withOpacity(.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: active ? c : c.withOpacity(.20), width: 1.5),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : c,
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class PickerRow extends StatelessWidget {
  const PickerRow({this.values, this.active, this.onTap});
  final List<String> values;
  final String active;
  final ValueChanged<String> onTap;
  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: values.map((String v) {
          final bool selected = v == active;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () => onTap(v),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? C.primary : C.primary.withOpacity(.07),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(v,
                      style: TextStyle(
                          color: selected ? Colors.white : C.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PickerGrid extends StatelessWidget {
  const PickerGrid({this.values, this.activeStartsWith, this.onTap});
  final List<String> values;
  final String activeStartsWith;
  final ValueChanged<String> onTap;
  @override
  Widget build(BuildContext context) {
    return FCard(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: values.map((String v) {
          final bool active = v.contains(activeStartsWith);
          return GestureDetector(
            onTap: () => onTap(v),
            child: Container(
              width: 174,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: active ? C.blue : C.blue.withOpacity(.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(v,
                  style: TextStyle(
                      color: active ? Colors.white : C.foreground,
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w700)),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class AiPlanner extends StatelessWidget {
  const AiPlanner({this.destination, this.shown, this.onTap});
  final String destination;
  final bool shown;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: <Color>[Color(0xFF0A2E1A), Color(0xFF1A5C38), C.primary, C.secondary]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(color: const Color(0xFF0A2E1A).withOpacity(.35), blurRadius: 32, offset: const Offset(0, 12))
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                IconBubble(Icons.star, Colors.amber, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('AI Suggestions',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800)),
                      Text(
                          destination.isEmpty
                              ? 'Add a destination to get personalized ideas'
                              : 'Generate smart tips for $destination',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: ActionButton(
              label: shown ? 'Regenerate Ideas' : 'Generate AI Ideas',
              icon: Icons.build,
              color: Colors.white.withOpacity(.12),
              textColor: Colors.white,
              borderColor: Colors.white24,
              onTap: onTap,
            ),
          ),
          if (shown)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: <String>[
                  '🌅 Book sunrise tours early',
                  '🍽️ Reserve restaurants 2 weeks ahead',
                  '📱 Download offline maps before you go',
                ]
                    .map((String s) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.08),
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(s,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
