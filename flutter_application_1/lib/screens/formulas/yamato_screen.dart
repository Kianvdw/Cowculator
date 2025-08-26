import 'package:flutter/material.dart';

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
  double? _estimatedWeight;

  void _calculateWeight() {
    final girth = double.tryParse(_girthController.text);
    final length = double.tryParse(_lengthController.text);
    final height = double.tryParse(_heightController.text);
    final depth = double.tryParse(_depthController.text);

    if (girth != null && length != null && height != null && depth != null) {
      // Example Yamato formula (you may substitute with actual coefficients)
     final weight = -173.5 + (1.2 * girth) + (1.1 * length) + (0.75 * height) + (0.88 * depth);
      setState(() => _estimatedWeight = weight);
    } else {
      setState(() => _estimatedWeight = null);
    }
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
            const SizedBox(height: 16),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _depthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Chest Depth (cm)',
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
