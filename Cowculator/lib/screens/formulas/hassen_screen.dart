import 'package:flutter/material.dart';

class HassenScreen extends StatefulWidget {
  const HassenScreen({super.key});

  @override
  State<HassenScreen> createState() => _HassenScreenState();
}

class _HassenScreenState extends State<HassenScreen> {
  final TextEditingController _girthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  double? _estimatedWeight;

  void _calculateWeight() {
  final girth = double.tryParse(_girthController.text);
  final length = double.tryParse(_lengthController.text);

  if (girth != null && length != null) {
    // Correct Hassen formula
    final weight = -57.89 + (1.39 * girth) + (0.47 * length);
    setState(() => _estimatedWeight = weight);
  } else {
    setState(() => _estimatedWeight = null);
  }
}

  @override
  void dispose() {
    _girthController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: _girthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Heart Girth (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lengthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Body Length (cm)',
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
              const Text("Enter valid measurements to calculate weight."),
          ],
        ),
      ),
    );
  }
}
