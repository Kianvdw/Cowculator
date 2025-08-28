import 'package:flutter/material.dart';
import 'cow_formula_selector.dart';
import 'settings_screen.dart';
import 'horse_formula_selector.dart';

class AnimalSelectorScreen extends StatelessWidget {
  final void Function(ThemeMode) onThemeChanged;
  final ThemeMode themeMode;

  const AnimalSelectorScreen({
    super.key,
    required this.onThemeChanged,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Animal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    currentTheme: themeMode,
                    onThemeChanged: onThemeChanged,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose Animal Type',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FormulaSelectorScreen()),
                  );
                },
                child: const Text('Cow'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HorseFormulaSelectorScreen()),
                  );
                },
                child: const Text('Horse'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sheep support coming soon.')),
                  );
                },
                child: const Text('Sheep'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pig support coming soon.')),
                  );
                },
                child: const Text('Pig'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
