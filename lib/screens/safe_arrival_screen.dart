import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/mock_data.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SafeArrivalScreen extends StatelessWidget {
  const SafeArrivalScreen({super.key});

  Widget _step(String title, String sub, bool done) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: done ? kGreen : const Color(0xFF8A94AD),
            child: Icon(done ? Icons.check : Icons.more_horiz, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              Text(sub, style: const TextStyle(fontSize: 12, color: kMuted)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final bus = kBuses[app.selectedBus];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    tooltip: 'Back',
                  ),
                  Text(app.me.travelDate, style: const TextStyle(color: Color(0xFFE3E1FF), fontSize: 13)),
                  const Text('Safe arrival check-in',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Panel(
              child: Column(
                children: [
                  _step('Departed', '${bus.depart} · ${bus.operator}', true),
                  _step('On the road', 'On schedule', true),
                  _step('Arrive at ${app.me.university.replaceAll('University', 'Uni')}', 'Expected ${bus.arrive}', app.arrived),
                ],
              ),
            ),
            Panel(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: app.trustedContact,
                    onChanged: app.setTrustedContact,
                    decoration: const InputDecoration(labelText: 'Trusted contact (gets an alert when you arrive)'),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Share live location', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Only during this trip'),
                    value: app.shareLocation,
                    onChanged: app.setSharing,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: kGreen),
                    onPressed: app.arrived ? null : app.markArrived,
                    child: Text(app.arrived ? 'Arrived safely' : 'I have arrived safely'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFB42318),
                      side: const BorderSide(color: Color(0xFFB42318), width: 1.5),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Need help?'),
                        content: const Text('Call the SAPS emergency number 10111.'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              launchUrl(Uri.parse('tel:10111'));
                            },
                            child: const Text('Call 10111'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Need help'),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
