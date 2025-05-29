import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/thought_provider.dart';

class AddThoughtScreen extends StatefulWidget {
  const AddThoughtScreen({super.key});

  @override
  State<AddThoughtScreen> createState() => _AddThoughtScreenState();
}

class _AddThoughtScreenState extends State<AddThoughtScreen> {
  final _textController = TextEditingController();
  String _category = 'Загальне';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Нова думка')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Ваша думка...'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _category,
              onChanged: (value) => setState(() => _category = value!),
              items: ['Загальне', 'Тривога', 'На потім']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_textController.text.trim().isEmpty) return;
                Provider.of<ThoughtProvider>(context, listen: false)
                    .addThought(_textController.text.trim(), _category);
                Navigator.pop(context);
              },
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
