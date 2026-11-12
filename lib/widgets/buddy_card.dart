import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../screens/chat_screen.dart';
import '../screens/match_detail_screen.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'common.dart';

class BuddyCard extends StatelessWidget {
  final Student s;
  const BuddyCard(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final isConnected = app.connected.contains(s.id);
    final isRequested = app.requested.contains(s.id);
    final km = app.distanceKm(s).round();

    Widget action;
    if (isConnected) {
      action = OutlinedButton(
        style: OutlinedButton.styleFrom(minimumSize: const Size(80, 44)),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(chatId: s.id, title: s.shortName, subtitle: '${s.town} to ${s.university}'),
          ),
        ),
        child: const Text('Chat'),
      );
    } else if (isRequested) {
      action = const FilledButton(onPressed: null, child: Text('Sent'));
    } else {
      action = FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size(80, 44)),
        onPressed: () => app.connect(s),
        child: const Text('Connect'),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MatchDetailScreen(s))),
      child: Panel(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Row(
          children: [
            Avatar(s),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(s.shortName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      ),
                      if (s.verified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, size: 16, color: kGreen),
                      ],
                    ],
                  ),
                  Text('${s.town} · ${s.course}',
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: kMuted)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Pill('${app.score(s)}% match', bg: const Color(0xFFFFF1D6), fg: const Color(0xFF8A5200)),
                      Pill('$km km'),
                      Pill(s.travelDate),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            action,
          ],
        ),
      ),
    );
  }
}
