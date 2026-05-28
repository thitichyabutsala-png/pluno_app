import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {this.color,
      this.icon,
      this.iconColor,
      this.size,
      this.shadow,
      this.onTap});
  final Color color;
  final IconData icon;
  final Color iconColor;
  final double size;
  final Color shadow;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: shadow == null
              ? null
              : <BoxShadow>[
                  BoxShadow(
                      color: shadow,
                      blurRadius: 28,
                      offset: const Offset(0, 10))
                ],
        ),
        child: Icon(icon, size: size * .48, color: iconColor),
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText(this.icon, this.text, {this.color, this.textColor});
  final IconData icon;
  final String text;
  final Color color;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor, fontSize: 13)),
        ),
      ],
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip(this.icon, this.label, {this.color, this.bg});
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: bg ?? color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class AvatarBubble extends StatelessWidget {
  const AvatarBubble(this.text, {this.size});
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: C.primary.withOpacity(0.10), shape: BoxShape.circle),
      child: Text(text, style: TextStyle(fontSize: size * .48)),
    );
  }
}

class IconBubble extends StatelessWidget {
  const IconBubble(this.icon, this.color, {this.size});
  final IconData icon;
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) {
    final double s = size ?? 36;
    return Container(
      width: s,
      height: s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(s * .33)),
      child: Icon(icon, color: color, size: s * .45),
    );
  }
}

class FrostTag extends StatelessWidget {
  const FrostTag({this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(0.28)),
      ),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class TabButton extends StatelessWidget {
  const TabButton(this.label, this.active, this.onTap);
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: active ? null : Border.all(color: C.line),
          ),
          child: Text(label,
              style: TextStyle(
                  color: active ? Colors.white : const Color(0xFF8A8A8A),
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}

class TinyStat extends StatelessWidget {
  const TinyStat(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Icon(icon, size: 13, color: Colors.black38),
      const SizedBox(width: 3),
      Text(label,
          style: const TextStyle(
              color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w500)),
    ]);
  }
}

class MetaCell extends StatelessWidget {
  const MetaCell(this.icon, this.value, this.label, {this.last = false});
  final IconData icon;
  final String value;
  final String label;
  final bool last;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
              right: last ? BorderSide.none : const BorderSide(color: C.line)),
        ),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 15, color: C.primary),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
            Text(label.toUpperCase(),
                style: const TextStyle(
                    color: Colors.black38,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton(
      {this.label,
      this.icon,
      this.color,
      this.textColor,
      this.borderColor,
      this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border:
              borderColor == null ? null : Border.all(color: borderColor, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: (color ?? Colors.black).withOpacity(.18),
                blurRadius: 16,
                offset: const Offset(0, 8))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: textColor, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: textColor, fontSize: 15, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class FCard extends StatelessWidget {
  const FCard({this.child, this.padding});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: C.primary.withOpacity(0.08)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: C.primary.withOpacity(.07), blurRadius: 20, offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Text(label.toUpperCase(),
          style: const TextStyle(
              color: C.muted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2)),
    );
  }
}

class CoverPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Container(
        height: 164,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[
              Color(0xFFD4EDE2),
              Color(0xFFE8F5EF),
              Color(0xFFF5F0E8),
              Color(0xFFE8F5F0)
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(Icons.camera_alt, color: C.primary, size: 28),
            SizedBox(height: 8),
            Text('Add Cover Photo',
                style: TextStyle(color: C.primary, fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text('Upload or choose a photo',
                style: TextStyle(color: C.muted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  const DateBox({this.label, this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.primary.withOpacity(.15), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label.toUpperCase(),
              style: const TextStyle(
                  color: C.muted, fontSize: 10, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: C.foreground, fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class ActionChipButton extends StatelessWidget {
  const ActionChipButton({this.label, this.icon, this.enabled, this.onTap});
  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(colors: <Color>[C.primary, C.secondary])
              : null,
          color: enabled ? null : Colors.black.withOpacity(.08),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: enabled ? Colors.white : Colors.black38, size: 14),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: enabled ? Colors.white : Colors.black38,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
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
                  fontWeight: FontWeight.w700,
                  letterSpacing: .9)),
          const Spacer(),
          if (badge != null) InfoChip(Icons.check, badge, color: C.primary),
        ],
      ),
    );
  }
}

class DashedButton extends StatelessWidget {
  const DashedButton({this.label, this.icon});
  final String label;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: C.primary.withOpacity(.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.primary.withOpacity(.30), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: C.primary, size: 14),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  color: C.primary, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  const ProfileStat(this.value, this.label);
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        Text(label, style: const TextStyle(color: C.muted, fontSize: 12)),
      ],
    );
  }
}
