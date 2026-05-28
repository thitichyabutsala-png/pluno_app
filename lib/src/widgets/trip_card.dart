import 'package:flutter/material.dart';

import '../i18n/translations.dart';
import '../models/trip.dart';
import '../theme/app_colors.dart';
import '../utils/trip_utils.dart';
import 'common.dart';

class TripCard extends StatelessWidget {
  const TripCard({this.trip, this.t, this.onTap, this.onSave});
  final Trip trip;
  final T t;
  final VoidCallback onTap;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.98,
                    child: Image.network(trip.image, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            Colors.black.withOpacity(0.25)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CircleButton(
                      color: Colors.white.withOpacity(0.92),
                      icon: trip.saved ? Icons.bookmark : Icons.bookmark_border,
                      iconColor: trip.saved ? C.primary : C.muted,
                      size: 36,
                      onTap: onSave,
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Row(
                      children: trip.tags.take(2).map((String tag) {
                        final Color color = tagColor(tag);
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.86),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(tag,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(trip.destination,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: C.foreground,
                                  fontSize: 18,
                                  height: 1.2,
                                  fontWeight: FontWeight.w700)),
                        ),
                        const Icon(Icons.bookmark_border,
                            size: 14, color: C.muted),
                        const SizedBox(width: 3),
                        Text(formatSaves(trip.saves),
                            style: const TextStyle(
                                color: C.muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    IconText(Icons.location_on, trip.location,
                        color: C.primary, textColor: C.muted),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        InfoChip(Icons.attach_money, trip.budget,
                            color: C.primary),
                        const SizedBox(width: 8),
                        InfoChip(Icons.access_time, trip.duration,
                            color: C.muted, bg: Colors.black.withOpacity(0.04)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(height: 1, color: Colors.black.withOpacity(0.05)),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        AvatarBubble(trip.creator.avatar, size: 28),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(trip.creator.handle,
                              style: const TextStyle(
                                  color: C.muted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                        ),
                        InfoChip(
                            Icons.call_split, '${trip.remixes} ${t.remixes}',
                            color: C.accent, bg: C.accent.withOpacity(0.10)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
