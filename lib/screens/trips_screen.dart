import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/mock_data.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'chat_screen.dart';
import 'safe_arrival_screen.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  Future<void> _book(BuildContext context) async {
    final ok = await launchUrl(Uri.parse('https://bus.travelstart.co.za'), mode: LaunchMode.externalApplication)
        .catchError((_) => false);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open the booking site.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final going = app.matches().where((s) => s.travelDate == app.me.travelDate).length;

    return Column(
      children: [
        HeaderBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${app.me.province} to ${app.me.university.replaceAll('University', 'Uni')} · ${app.me.travelDate}',
                  style: const TextStyle(color: Color(0xFFE3E1FF), fontSize: 13)),
              const SizedBox(height: 4),
              const Text('Travel together',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              Text('$going buddies on this date', style: const TextStyle(color: kAccent, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: 16),
            children: [
              for (var i = 0; i < kBuses.length; i++)
                GestureDetector(
                  onTap: () => app.selectBus(i),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: app.selectedBus == i ? kPrimary : Colors.white, width: 2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(kBuses[i].operator, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                              Text('${kBuses[i].depart} to ${kBuses[i].arrive}${kBuses[i].tag.isEmpty ? '' : ' · ${kBuses[i].tag}'}',
                                  style: const TextStyle(fontSize: 12, color: kMuted)),
                            ],
                          ),
                        ),
                        Text(kBuses[i].price, style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF3730A3))),
                      ],
                    ),
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Sample data. Live fares would come from a booking partner.',
                    style: TextStyle(fontSize: 12, color: kMuted)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: app.joinedTrip
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    chatId: 'trip',
                                    title: '${app.me.province} trip group',
                                    subtitle: '${app.me.travelDate} · ${app.me.university}',
                                    group: true,
                                  ),
                                ),
                              )
                          : app.joinTrip,
                      child: Text(app.joinedTrip ? 'Open trip group' : 'Join trip group'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(onPressed: () => _book(context), child: const Text('Book on operator site')),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafeArrivalScreen())),
                      child: const Text('Safe arrival check-in'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
