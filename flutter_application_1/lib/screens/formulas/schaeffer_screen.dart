import 'package:flutter/material.dart';

class SchaefferScreen extends StatefulWidget {
  const SchaefferScreen({super.key});

  @override
  State<SchaefferScreen> createState() => _SchaefferScreenState();
}

class _SchaefferScreenState extends State<SchaefferScreen> {
  final TextEditingController _girthController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  double? _estimatedWeight;

  void _calculateWeight() {
  final girth = double.tryParse(_girthController.text);
  final length = double.tryParse(_lengthController.text);

  if (girth != null && length != null) {
    final weight = (girth * girth * length) / 10838.5;
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
