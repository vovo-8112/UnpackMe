import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/thought_provider.dart';
import '../widgets/thought_card.dart';
import 'add_thought_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final thoughts = Provider.of<ThoughtProvider>(context).thoughts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UnpackMe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoriesScreen()),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: thoughts
            .map((t) => ThoughtCard(
                  thought: t,
                  onDelete: () => Provider.of<ThoughtProvider>(context, listen: false)
                      .deleteThought(t.id),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddThoughtScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
