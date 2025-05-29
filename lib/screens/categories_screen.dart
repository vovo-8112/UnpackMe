import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Категорії')),
      body: const Center(child: Text('У майбутньому тут можна буде редагувати категорії')),
    );
  }
}
