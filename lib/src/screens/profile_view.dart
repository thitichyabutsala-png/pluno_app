import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/common.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 112),
      child: Column(
        children: <Widget>[
          FCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                AvatarBubble('✈️', size: 64),
                const SizedBox(height: 12),
                const Text('Pluno Traveler',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('@pluno',
                    style: TextStyle(color: C.muted, fontSize: 13)),
                const SizedBox(height: 18),
                Row(
                  children: <Widget>[
                    Expanded(child: ProfileStat('12', 'Trips')),
                    Expanded(child: ProfileStat('3.2k', 'Saves')),
                    Expanded(child: ProfileStat('469', 'Remixes')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
