import 'package:flutter/material.dart';
import 'formulas/horse_point_screen.dart';
import 'formulas/horse_stifle_screen.dart';
import 'formulas/horse_yearling_screen.dart';
import 'formulas/horse_foal_screen.dart';

class HorseFormulaSelectorScreen extends StatelessWidget {
  const HorseFormulaSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('Horse — Choose Formula')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFormulaTile(
            context,
            title: 'Adult — Point (recommended)',
            description: 'Point of shoulder → point of buttock\n±4–6% accuracy',
            screen: const HorsePointScreen(),
          ),
          _buildFormulaTile(
            context,
            title: 'Adult — Stifle',
            description: 'Point of shoulder → stifle/tail fold\n±8–12% accuracy',
            screen: const HorseStifleScreen(),
          ),
          _buildFormulaTile(
            context,
            title: 'Yearling',
            description: 'Age-adjusted divisor\n±6–10% accuracy',
            screen: const HorseYearlingScreen(),
          ),
          _buildFormulaTile(
            context,
            title: 'Foal',
            description: 'Age-adjusted divisor\n±8–12% accuracy',
            screen: const HorseFoalScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaTile(
    BuildContext context, {
    required String title,
    required String description,
    required Widget screen,
  }) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surfaceContainerHighest; // same as cows
    final textColor = theme.colorScheme.onSurface;

    return Card(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: TextStyle(color: textColor)),
        // ignore: deprecated_member_use
        subtitle: Text(description, style: TextStyle(color: textColor.withOpacity(0.7))),
        trailing: Icon(Icons.arrow_forward_ios, color: textColor),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        ),
      ),
    );
  }
}
