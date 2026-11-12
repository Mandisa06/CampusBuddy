import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final people = app.students.where((s) => app.connected.contains(s.id)).toList();
    final empty = people.isEmpty && !app.joinedTrip;

    return Column(
      children: [
        const HeaderBox(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Chats', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
          ),
        ),
        Expanded(
          child: empty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No chats yet. Connect with a buddy and they will appear here.',
                        textAlign: TextAlign.center, style: TextStyle(color: kMuted)),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.only(top: 12),
                  children: [
                    if (app.joinedTrip)
                      _tile(
                        context,
                        leading: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.directions_bus, color: Colors.white),
                        ),
                        title: '${app.me.province} trip group',
                        last: app.chats['trip']?.isNotEmpty == true ? app.chats['trip']!.last.text : 'Say hi',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: 'trip',
                              title: '${app.me.province} trip group',
                              subtitle: '${app.me.travelDate} · ${app.me.university}',
                              group: true,
                            ),
                          ),
                        ),
                      ),
                    for (final s in people)
                      _tile(
                        context,
                        leading: Avatar(s),
                        title: s.shortName,
                        last: app.chats[s.id]?.isNotEmpty == true ? app.chats[s.id]!.last.text : 'Say hi',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(chatId: s.id, title: s.shortName, subtitle: '${s.town} to ${s.university}'),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _tile(BuildContext context, {required Widget leading, required String title, required String last, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Panel(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  Text(last, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kMuted, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
