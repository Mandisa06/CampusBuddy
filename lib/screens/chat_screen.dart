import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  final String subtitle;
  final bool group;
  const ChatScreen({super.key, required this.chatId, required this.title, required this.subtitle, this.group = false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _send(AppState app) {
    final t = _text.text.trim();
    if (t.isEmpty) return;
    app.sendMessage(widget.chatId, t, reply: !widget.group);
    _text.clear();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final msgs = app.chats[widget.chatId] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            Text(widget.subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFFE3E1FF))),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thanks. Our team will review this report.')),
                );
              } else if (v == 'block') {
                app.block(widget.chatId);
                Navigator.pop(context);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'report', child: Text('Report')),
              if (!widget.group) const PopupMenuItem(value: 'block', child: Text('Block')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: msgs.length,
              itemBuilder: (_, i) {
                final m = msgs[i];
                return Align(
                  alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 280),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: m.mine ? kPrimary : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.group && !m.mine)
                          Text(m.from, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF3730A3))),
                        Text(m.text, style: TextStyle(color: m.mine ? Colors.white : kInk, height: 1.35)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _text,
                      onSubmitted: (_) => _send(app),
                      decoration: const InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: () => _send(app), icon: const Icon(Icons.send), tooltip: 'Send'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
