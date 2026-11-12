import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = <(String, String, String)>[
      ('firstNameOnly', 'Show first name only', 'Others see "Sipho M." not your full name'),
      ('hideProfile', 'Hide my profile from search', 'Only people I connect with see me'),
      ('approxLocation', 'Approximate location only', 'Never share an exact address'),
      ('appLock', 'Fingerprint app lock', 'Demo toggle. Add local_auth to enforce it'),
      ('calendar', 'Calendar reminders', 'Trip dates and registration deadlines'),
    ];
    final blocked = app.students.where((s) => app.blocked.contains(s.id)).toList();

    return Column(
      children: [
        HeaderBox(
          child: Row(
            children: [
              Avatar(app.me, size: 56),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(app.me.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    Text('${app.me.course} · ${app.me.province}', style: const TextStyle(color: Color(0xFFE3E1FF), fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(app.badge ? 'Verified student' : 'Not verified yet',
                        style: const TextStyle(color: kAccent, fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 16),
            children: [
              Panel(
                child: Column(
                  children: [
                    for (final it in items)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(it.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        subtitle: Text(it.$3, style: const TextStyle(fontSize: 12)),
                        value: app.settings[it.$1] ?? false,
                        onChanged: (v) => app.setSetting(it.$1, v),
                      ),
                  ],
                ),
              ),
              Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Blocked users (${blocked.length})', style: const TextStyle(fontWeight: FontWeight.w800)),
                    if (blocked.isEmpty) const Text('Nobody blocked.', style: TextStyle(color: kMuted)),
                    for (final s in blocked)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Avatar(s, size: 40),
                        title: Text(s.shortName),
                        trailing: TextButton(onPressed: () => app.unblock(s.id), child: const Text('Unblock')),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton(onPressed: app.signOut, child: const Text('Sign out')),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
