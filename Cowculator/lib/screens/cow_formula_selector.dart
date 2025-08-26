import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/formulas/schaeffer_screen.dart';
import 'package:flutter_application_1/screens/formulas/hassen_screen.dart';
import 'package:flutter_application_1/screens/formulas/yamato_screen.dart';
import 'package:flutter_application_1/screens/formulas/girth_only_screen.dart';

class FormulaSelectorScreen extends StatelessWidget {
  const FormulaSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Formula')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFormulaTile(
            context,
            title: 'Schaeffer (Girth² × Length)',
            description: '±5–8% accuracy',
            screen: const SchaefferScreen(),
          ),
          _buildFormulaTile(
            context,
            title: 'Hassen Regression (Linear)',
            description: '±3–6% accuracy',
            screen: const HassenScreen(),
          ),
          _buildFormulaTile(
            context,
            title: 'Yamato 4-variable',
            description: '±1–3% accuracy',
            screen: const YamatoScreen(),
          ),
          _buildFormulaTile(
            context,
            title: 'Girth-only',
            description: '±8–12% accuracy',
            screen: const GirthOnlyScreen(),
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
    final surfaceColor = theme.colorScheme.surfaceContainerHighest;
    final textColor = theme.colorScheme.onSurface;

    return Card(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: TextStyle(color: textColor)),
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
