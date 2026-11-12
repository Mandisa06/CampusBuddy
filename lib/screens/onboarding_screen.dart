import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _course = TextEditingController();
  String _province = 'Mpumalanga';
  String _uni = 'Walter Sisulu University';
  String _date = '17 Jan';
  final Set<String> _interests = {};
  bool _consent = false;

  @override
  void dispose() {
    _name.dispose();
    _course.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    if (!_consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the privacy consent (POPIA) to continue.')),
      );
      return;
    }
    context.read<AppState>().signIn(Student(
          id: 'me',
          name: _name.text.trim(),
          province: _province,
          town: _province,
          university: _uni,
          course: _course.text.trim(),
          interests: _interests.toList(),
          travelDate: _date,
          color: kPrimary,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(16)),
                    child: const Text('CB', style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF2A1B00))),
                  ),
                  const SizedBox(height: 18),
                  const Text('Meet your crew before day one',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.15)),
                  const SizedBox(height: 8),
                  const Text('Match with first-years from your province heading to your university.',
                      style: TextStyle(color: Color(0xFFE3E1FF), fontSize: 14, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _form,
              child: Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _name.text = 'Thandi Ndlovu';
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Demo only: real Google sign-in needs Firebase Auth (see README).'),
                        ));
                      },
                      child: const Text('Continue with Google'),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: (v) => (v == null || v.trim().length < 2) ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _province,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Home province'),
                      items: [for (final p in kProvinces) DropdownMenuItem(value: p, child: Text(p))],
                      onChanged: (v) => setState(() => _province = v!),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _uni,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'University'),
                      items: [for (final u in kUniversities) DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))],
                      onChanged: (v) => setState(() => _uni = v!),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _course,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Course'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your course' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _date,
                      decoration: const InputDecoration(labelText: 'Travel date'),
                      items: [for (final d in kDates) DropdownMenuItem(value: d, child: Text(d))],
                      onChanged: (v) => setState(() => _date = v!),
                    ),
                    const SizedBox(height: 14),
                    const Text('Interests', style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final i in kInterests)
                          FilterChip(
                            label: Text(i),
                            selected: _interests.contains(i),
                            onSelected: (on) => setState(() => on ? _interests.add(i) : _interests.remove(i)),
                          ),
                      ],
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      value: _consent,
                      onChanged: (v) => setState(() => _consent = v ?? false),
                      title: const Text(
                        'I agree to share my first name, province and university with matched students (POPIA).',
                        style: TextStyle(fontSize: 12, color: kMuted),
                      ),
                    ),
                    FilledButton(onPressed: _submit, child: const Text('Find my buddies')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
