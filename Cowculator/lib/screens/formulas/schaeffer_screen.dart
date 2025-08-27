import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/unit_settings.dart';
import '../../../core/units.dart';

class SchaefferScreen extends StatefulWidget {
  const SchaefferScreen({super.key});

  @override
  State<SchaefferScreen> createState() => _SchaefferScreenState();
}

class _SchaefferScreenState extends State<SchaefferScreen> {
  final TextEditingController _girthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  double? _estimatedDisplayWeight; // kg or lb depending on setting
  String? _error;

  // Core Schaeffer calculation in METRIC ONLY
  // Inputs: girth (cm), length (cm) -> returns weight in kg
  double _schaefferKg(double girthCm, double lengthCm) {
    return (girthCm * girthCm * lengthCm) / 10838.5;
  }

  void _calculateWeight(BuildContext context) {
    setState(() {
      _error = null;
      _estimatedDisplayWeight = null;
    });

    final unitSettings = context.read<UnitSettings>();

    final girthUi = double.tryParse(_girthController.text.trim());
    final lengthUi = double.tryParse(_lengthController.text.trim());

    if (girthUi == null || lengthUi == null) {
      setState(() => _error = "Please enter valid numbers for both measurements.");
      return;
    }
    if (girthUi <= 0 || lengthUi <= 0) {
      setState(() => _error = "Measurements must be greater than zero.");
      return;
    }

    // Convert UI -> METRIC (cm) for calculation
    final girthCm = unitSettings.uiLengthToMetric(girthUi);
    final lengthCm = unitSettings.uiLengthToMetric(lengthUi);

    final weightKg = _schaefferKg(girthCm, lengthCm);

    // Display result in current unit system
    final display = unitSettings.isMetric ? weightKg : Units.kgToLb(weightKg);

    setState(() => _estimatedDisplayWeight = display);
  }

  @override
  void dispose() {
    _girthController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitSettings = context.watch<UnitSettings>();
    final lengthUnit = Units.lengthLabel(unitSettings.system); // cm or in
    final weightUnit = Units.weightLabel(unitSettings.system); // kg or lb

    return Scaffold(
      appBar: AppBar(title: const Text("Schaeffer Formula")),
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
              "- Measure Heart Girth just behind the front legs around the chest.\n"
              "- Measure Body Length from shoulder to pin bone (above the tail).\n"
              "- Ensure the animal is calm and standing square.",
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
            const SizedBox(height: 16),

            // Body Length
            TextField(
              controller: _lengthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Body Length ($lengthUnit)',
                hintText: unitSettings.isMetric ? "e.g., 120" : "e.g., 47.2",
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
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              )
            else if (_estimatedDisplayWeight != null)
              Text(
                'Estimated Weight: ${_estimatedDisplayWeight!.toStringAsFixed(2)} $weightUnit',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            else
              const Text("Enter valid measurements to calculate weight."),
          ],
        ),
      ),
    );
  }
}
