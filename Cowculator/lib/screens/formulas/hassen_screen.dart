import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/unit_settings.dart';
import '../../../core/units.dart';

class HassenScreen extends StatefulWidget {
  const HassenScreen({super.key});

  @override
  State<HassenScreen> createState() => _HassenScreenState();
}

class _HassenScreenState extends State<HassenScreen> {
  final TextEditingController _girthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();

  double? _estimatedDisplayWeight; // kg or lb depending on setting
  String? _error;

  // Hassen regression in METRIC ONLY (inputs in cm, output kg)
  // weight_kg = -57.89 + (1.39 * girth_cm) + (0.47 * length_cm)
  double _hassenKg({required double girthCm, required double lengthCm}) {
    return -57.89 + (1.39 * girthCm) + (0.47 * lengthCm);
  }

  void _calculateWeight(BuildContext context) {
    setState(() {
      _error = null;
      _estimatedDisplayWeight = null;
    });

    final unitSettings = context.read<UnitSettings>();

    final girthUi  = double.tryParse(_girthController.text.trim());
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
    final girthCm  = unitSettings.uiLengthToMetric(girthUi);
    final lengthCm = unitSettings.uiLengthToMetric(lengthUi);

    final weightKg = _hassenKg(girthCm: girthCm, lengthCm: lengthCm);

    // Convert to display unit
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

    InputDecoration _dec(String label) => InputDecoration(
          labelText: "$label ($lengthUnit)",
          border: const OutlineInputBorder(),
          hintText: unitSettings.isMetric ? "e.g., 150" : "e.g., 59.0",
        );

    return Scaffold(
      appBar: AppBar(title: const Text("Hassen Regression Formula")),
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
              "- Heart Girth: Wrap tape behind front legs and over withers.\n"
              "- Body Length: Measure from point of shoulder to pin bone.\n"
              "- Make sure the cow is standing level and relaxed.",
            ),
            const SizedBox(height: 20),

            // Heart Girth
            TextField(
              controller: _girthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Heart Girth'),
            ),
            const SizedBox(height: 16),

            // Body Length
            TextField(
              controller: _lengthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Body Length'),
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
              const Text("Enter valid measurements to calculate weight."),
          ],
        ),
      ),
    );
  }
}
