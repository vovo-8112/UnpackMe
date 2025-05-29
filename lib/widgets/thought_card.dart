import 'package:flutter/material.dart';
import '../models/thought.dart';

class ThoughtCard extends StatelessWidget {
  final Thought thought;
  final VoidCallback onDelete;

  const ThoughtCard({super.key, required this.thought, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFFFDF6EC),
      child: ListTile(
        title: Text(thought.text),
        subtitle: Text('Категорія: ${thought.category}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
