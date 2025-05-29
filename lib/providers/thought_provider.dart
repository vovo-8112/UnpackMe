import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/thought.dart';

class ThoughtProvider with ChangeNotifier {
  final List<Thought> _thoughts = [];

  List<Thought> get thoughts => _thoughts;

  void addThought(String text, String category) {
    final newThought = Thought(
      id: const Uuid().v4(),
      text: text,
      category: category,
    );
    _thoughts.add(newThought);
    notifyListeners();
  }

  void deleteThought(String id) {
    _thoughts.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}
