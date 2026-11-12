import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/buddy_card.dart';
import '../widgets/common.dart';

class BuddiesScreen extends StatefulWidget {
  const BuddiesScreen({super.key});
  @override
  State<BuddiesScreen> createState() => _BuddiesScreenState();
}

class _BuddiesScreenState extends State<BuddiesScreen> {
  bool _sameDate = false;
  bool _anyProvince = false;
  int? _radius; // km, null = any

  Future<void> _toggleLocation(AppState app, bool on) async {
    if (!on) {
      app.disableLocation();
      return;
    }
    final err = await app.enableLocation();
    if (err != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    var list = app.matches(anyProvince: _anyProvince);
    if (_sameDate) list = list.where((s) => s.travelDate == app.me.travelDate).toList();
    if (_radius != null) list = list.where((s) => app.distanceKm(s) <= _radius!).toList();
    list.sort((a, b) => app.score(b).compareTo(app.score(a)));
    final first = app.me.name.split(' ').first;

    return Column(
      children: [
        HeaderBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi $first', style: const TextStyle(color: Color(0xFFE3E1FF), fontSize: 13)),
              const SizedBox(height: 4),
              Text('${list.length} buddies on your route',
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  Pill(app.me.province, bg: kAccent, fg: const Color(0xFF2A1B00)),
                  Pill(app.me.university.replaceAll('University', 'Uni'), bg: Colors.white),
                  Pill(app.me.travelDate, bg: const Color(0xFF5B52DA), fg: Colors.white),
                ],
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Use my location'),
                selected: app.useRealLocation,
                onSelected: (v) => _toggleLocation(app, v),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Same date'),
                selected: _sameDate,
                onSelected: (v) => setState(() => _sameDate = v),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Other provinces'),
                selected: _anyProvince,
                onSelected: (v) => setState(() => _anyProvince = v),
              ),
              const SizedBox(width: 8),
              for (final r in [5, 20, 50, 500]) ...[
                ChoiceChip(
                  label: Text('Within $r km'),
                  selected: _radius == r,
                  onSelected: (v) => setState(() => _radius = v ? r : null),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.group_off, size: 48, color: kMuted),
                        SizedBox(height: 12),
                        Text('No buddies yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(height: 6),
                        Text('Try "Other provinces" or widen the distance. New students join every day.',
                            textAlign: TextAlign.center, style: TextStyle(color: kMuted)),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  itemCount: list.length,
                  itemBuilder: (_, i) => BuddyCard(list[i]),
                ),
        ),
      ],
    );
  }
}
