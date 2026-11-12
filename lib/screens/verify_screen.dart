import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Demo verification: the code is shown on screen. In production, a backend
/// (e.g. Firebase Auth email link) would send it to the university email.
class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  static const _demoCode = '482913';
  final _email = TextEditingController();
  final _code = TextEditingController();
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  void _send() {
    if (!_email.text.contains('@') || !_email.text.contains('.ac.za')) {
      setState(() => _error = 'Use your university email (ends with .ac.za).');
      return;
    }
    setState(() {
      _error = null;
      _sent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Demo code: 482913 (a real app emails this code)')),
    );
  }

  void _verify() {
    if (_code.text.trim() == _demoCode) {
      context.read<AppState>().completeVerification(withBadge: true);
    } else {
      setState(() => _error = 'That code is not correct.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Step 2 of 2', style: TextStyle(color: Color(0xFFE3E1FF), fontSize: 13)),
                  SizedBox(height: 4),
                  Text('Verify you are a student',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'University email', hintText: 'name@wsu.ac.za'),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _send, child: const Text('Send code')),
                  if (_sent) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _code,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(labelText: '6-digit code'),
                    ),
                    FilledButton(onPressed: _verify, child: const Text('Verify')),
                  ],
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(_error!, style: const TextStyle(color: Color(0xFFB42318), fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
            Panel(
              child: Row(
                children: const [
                  Icon(Icons.verified, color: kGreen),
                  SizedBox(width: 12),
                  Expanded(child: Text('Verified students get a badge, so others know you are a real first-year.', style: TextStyle(fontSize: 13))),
                ],
              ),
            ),
            TextButton(
              onPressed: () => context.read<AppState>().completeVerification(withBadge: false),
              child: const Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }
}
