import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/unit_settings.dart';
import '../../../core/units.dart';

class GirthOnlyScreen extends StatefulWidget {
  const GirthOnlyScreen({super.key});

  @override
  State<GirthOnlyScreen> createState() => _GirthOnlyScreenState();
}

class _GirthOnlyScreenState extends State<GirthOnlyScreen> {
  final TextEditingController _girthController = TextEditingController();

  double? _estimatedDisplayWeight; // kg or lb depending on current unit
  String? _error;

  // Girth-only formula in METRIC ONLY (input cm -> output kg).
  // Using your example: weight (kg) = (girth^2 * 300) / 10000
  // Replace with your validated constant when ready.
  double _girthOnlyKg(double girthCm) {
    return (girthCm * girthCm * 300) / 10000.0;
  }

  void _calculateWeight(BuildContext context) {
    setState(() {
      _error = null;
      _estimatedDisplayWeight = null;
    });

    final unitSettings = context.read<UnitSettings>();

    final girthUi = double.tryParse(_girthController.text.trim());
    if (girthUi == null) {
      setState(() => _error = "Please enter a valid number for heart girth.");
      return;
    }
    if (girthUi <= 0) {
      setState(() => _error = "Measurement must be greater than zero.");
      return;
    }

    // Convert UI -> METRIC (cm)
    final girthCm = unitSettings.uiLengthToMetric(girthUi);

    // Calculate in kg
    final weightKg = _girthOnlyKg(girthCm);

    // Convert to display unit
    final display = unitSettings.isMetric ? weightKg : Units.kgToLb(weightKg);

    setState(() => _estimatedDisplayWeight = display);
  }

  @override
  void dispose() {
    _girthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitSettings = context.watch<UnitSettings>();
    final lengthUnit = Units.lengthLabel(unitSettings.system); // cm or in
    final weightUnit = Units.weightLabel(unitSettings.system); // kg or lb

    return Scaffold(
      appBar: AppBar(title: const Text("Girth-Only Formula")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Instructions:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "- Measure the heart girth (chest circumference) just behind the front legs and over the withers.\n"
              "- Use a soft measuring tape and ensure the animal is calm and standing straight.\n"
              "- This formula estimates weight from girth only.",
            ),
            const SizedBox(height: 20),

            // Heart Girth
            TextField(
              controller: _girthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Heart Girth ($lengthUnit)',
                hintText: unitSettings.isMetric ? "e.g., 150" : "e.g., 59.0",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _calculateWeight(context),
              child: const Text('Estimate Weight'),
            ),
            const SizedBox(height: 20),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_estimatedDisplayWeight != null)
              Text(
                'Estimated Weight: ${_estimatedDisplayWeight!.toStringAsFixed(2)} $weightUnit',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            else
              const Text("Enter a valid girth measurement to calculate weight."),
          ],
        ),
      ),
    );
  }
}
