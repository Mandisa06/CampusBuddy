import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class MatchDetailScreen extends StatelessWidget {
  final Student s;
  const MatchDetailScreen(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final parts = app.breakdown(s);
    final isConnected = app.connected.contains(s.id);
    final isRequested = app.requested.contains(s.id);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBox(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      tooltip: 'Back',
                    ),
                  ),
                  Avatar(s, size: 72),
                  const SizedBox(height: 12),
                  Text(s.shortName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                  Text('${s.town} · ${s.course}${s.verified ? ' · Verified' : ''}',
                      style: const TextStyle(color: Color(0xFFE3E1FF), fontSize: 13)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(20)),
                    child: Text('${app.score(s)}% match',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2A1B00))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Why you match', style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  for (final e in parts.entries) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text('${e.value}%', style: const TextStyle(color: Color(0xFF3730A3), fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(value: e.value / 100, minHeight: 10, backgroundColor: const Color(0xFFE8E6FF)),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Wrap(spacing: 8, children: [for (final i in s.interests) Pill(i)]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: (isConnected || isRequested) ? null : () => app.connect(s),
                  child: Text(isConnected ? 'Connected' : isRequested ? 'Request sent' : 'Connect'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
