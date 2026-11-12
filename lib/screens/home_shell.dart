import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme.dart';
import 'buddies_screen.dart';
import 'chats_screen.dart';
import 'settings_screen.dart';
import 'trips_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  static const _pages = [BuddiesScreen(), TripsScreen(), ChatsScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final banner = context.select<AppState, String?>((s) => s.banner);
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(index: _tab, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Buddies'),
              NavigationDestination(icon: Icon(Icons.directions_bus_outlined), selectedIcon: Icon(Icons.directions_bus), label: 'Trips'),
              NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chats'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        ),
        if (banner != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: kInk,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    textColor: Colors.white,
                    leading: Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(12)),
                      child: const Text('CB', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2A1B00), fontSize: 13)),
                    ),
                    title: const Text('Campus Buddy · now', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    subtitle: Text(banner, style: const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
