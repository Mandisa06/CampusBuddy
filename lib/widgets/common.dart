import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme.dart';

class HeaderBox extends StatelessWidget {
  final Widget child;
  const HeaderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 20, 24, 24),
      decoration: const BoxDecoration(
        color: kPrimary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: child,
    );
  }
}

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  const Panel({super.key, required this.child, this.margin = const EdgeInsets.fromLTRB(16, 0, 16, 12)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: Color(0x1A4338CA), blurRadius: 20, offset: Offset(0, 6))],
      ),
      child: child,
    );
  }
}

class Avatar extends StatelessWidget {
  final Student s;
  final double size;
  const Avatar(this.s, {super.key, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: s.color, borderRadius: BorderRadius.circular(size * 0.38)),
      child: Text(
        s.initials,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.3),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const Pill(this.text, {super.key, this.bg = kChip, this.fg = const Color(0xFF3730A3)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
