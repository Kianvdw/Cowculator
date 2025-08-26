import 'package:flutter/material.dart';

class GirthOnlyScreen extends StatefulWidget {
  const GirthOnlyScreen({super.key});

  @override
  State<GirthOnlyScreen> createState() => _GirthOnlyScreenState();
}

class _GirthOnlyScreenState extends State<GirthOnlyScreen> {
  final TextEditingController _girthController = TextEditingController();
  double? _estimatedWeight;

  void _calculateWeight() {
    final girth = double.tryParse(_girthController.text);

    if (girth != null) {
      // Example girth-only formula: weight (kg) = (girth^2) / 100
      final weight = (girth * girth * 300) / 10000;
      setState(() => _estimatedWeight = weight);
    } else {
      setState(() => _estimatedWeight = null);
    }
  }

  @override
  void dispose() {
    _girthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              "- This formula only estimates weight based on girth.",
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _girthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Heart Girth (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateWeight,
              child: const Text('Estimate Weight'),
            ),
            const SizedBox(height: 20),
            if (_estimatedWeight != null)
              Text(
                'Estimated Weight: ${_estimatedWeight!.toStringAsFixed(2)} kg',
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
