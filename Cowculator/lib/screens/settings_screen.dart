// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/unit_settings.dart';
import '../../core/units.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unitSettings = context.watch<UnitSettings>(); // <-- keep units independent of theme

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === Theme Section ===
          Text(
            'Theme Mode',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: currentTheme,
            onChanged: (v) { if (v != null) onThemeChanged(v); },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: currentTheme,
            onChanged: (v) { if (v != null) onThemeChanged(v); },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark Mode'),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (v) { if (v != null) onThemeChanged(v); },
          ),

          const SizedBox(height: 8),
          const Divider(height: 32),

          // === Units Section ===
          Text(
            'Units',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(unitSettings.isMetric ? 'Metric (kg, cm)' : 'Imperial (lb, in)'),
            subtitle: Text(
              'Toggle between ${unitSettings.isMetric ? "metric" : "imperial"} units. '
              'Calculations always use metric internally.',
              style: theme.textTheme.bodySmall,
            ),
            trailing: Switch(
              value: unitSettings.isMetric,
              onChanged: (v) {
                unitSettings.system = v ? UnitSystem.metric : UnitSystem.imperial;
              },
            ),
          ),
        ],
      ),
    );
  }
}
