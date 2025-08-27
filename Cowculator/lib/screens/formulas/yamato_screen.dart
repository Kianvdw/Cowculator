import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/unit_settings.dart';
import '../../../core/units.dart';

class YamatoScreen extends StatefulWidget {
  const YamatoScreen({super.key});

  @override
  State<YamatoScreen> createState() => _YamatoScreenState();
}

class _YamatoScreenState extends State<YamatoScreen> {
  final TextEditingController _girthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _depthController = TextEditingController();

  double? _estimatedDisplayWeight; // kg or lb depending on current unit
  String? _error;

  // Yamato calculation should operate in METRIC ONLY.
  // Inputs (all in cm): girth, length, height, depth -> returns kg.
  // Using your example coefficients; replace with validated ones when ready.
  double _yamatoKg({
    required double girthCm,
    required double lengthCm,
    required double heightCm,
    required double depthCm,
  }) {
    // Example: -173.5 + (1.2*girth) + (1.1*length) + (0.75*height) + (0.88*depth)
    return -173.5 +
        (1.2 * girthCm) +
        (1.1 * lengthCm) +
        (0.75 * heightCm) +
        (0.88 * depthCm);
  }

  void _calculateWeight(BuildContext context) {
    setState(() {
      _error = null;
      _estimatedDisplayWeight = null;
    });

    final unitSettings = context.read<UnitSettings>();

    final girthUi  = double.tryParse(_girthController.text.trim());
    final lengthUi = double.tryParse(_lengthController.text.trim());
    final heightUi = double.tryParse(_heightController.text.trim());
    final depthUi  = double.tryParse(_depthController.text.trim());

    // Basic validation
    if ([girthUi, lengthUi, heightUi, depthUi].any((v) => v == null)) {
      setState(() => _error = "Please enter valid numbers for all measurements.");
      return;
    }
    if (girthUi! <= 0 || lengthUi! <= 0 || heightUi! <= 0 || depthUi! <= 0) {
      setState(() => _error = "Measurements must be greater than zero.");
      return;
    }

    // Convert UI -> METRIC (cm)
    final girthCm  = unitSettings.uiLengthToMetric(girthUi);
    final lengthCm = unitSettings.uiLengthToMetric(lengthUi);
    final heightCm = unitSettings.uiLengthToMetric(heightUi);
    final depthCm  = unitSettings.uiLengthToMetric(depthUi);

    // Calculate in kg
    final weightKg = _yamatoKg(
      girthCm: girthCm,
      lengthCm: lengthCm,
      heightCm: heightCm,
      depthCm: depthCm,
    );

    // Convert to display unit
    final display = unitSettings.isMetric ? weightKg : Units.kgToLb(weightKg);

    setState(() => _estimatedDisplayWeight = display);
  }

  @override
  void dispose() {
    _girthController.dispose();
    _lengthController.dispose();
    _heightController.dispose();
    _depthController.dispose();
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
          hintText: unitSettings.isMetric ? "e.g., 120" : "e.g., 47.2",
        );

    return Scaffold(
      appBar: AppBar(title: const Text("Yamato 4-Variable Formula")),
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
              "- Heart Girth: Measure behind the front legs and over the withers.\n"
              "- Body Length: From the shoulder point to the pin bone.\n"
              "- Height: From ground to withers.\n"
              "- Chest Depth: From top of the back to bottom of the chest.\n"
              "- Ensure the animal is standing straight and calm.",
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
            const SizedBox(height: 16),

            // Height
            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Height'),
            ),
            const SizedBox(height: 16),

            // Chest Depth
            TextField(
              controller: _depthController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dec('Chest Depth'),
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
