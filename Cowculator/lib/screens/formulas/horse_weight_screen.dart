import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import '../../core/unit_settings.dart'; // global units provider
import '../../core/units.dart';         // Units.weightLabel(...) etc.

// Shared enum for all horse screens
enum HorseMethod { adultPoint, adultStifle, yearling, foal }

class HorseWeightScreen extends StatefulWidget {
  const HorseWeightScreen({
    super.key,
    this.fixedMethod,
    this.title = 'Horse Weight Estimator',
  });

  final HorseMethod? fixedMethod;
  final String title;

  @override
  State<HorseWeightScreen> createState() => _HorseWeightScreenState();
}

class _HorseWeightScreenState extends State<HorseWeightScreen> {
  final _formKey = GlobalKey<FormState>();

  late HorseMethod _method;

  final TextEditingController _girthCtrl = TextEditingController();
  final TextEditingController _lengthCtrl = TextEditingController();

  double? _resultKg;   // internal: store result in kg
  double? _errorBandKg;

  @override
  void initState() {
    super.initState();
    _method = widget.fixedMethod ?? HorseMethod.adultPoint;
  }

  @override
  void dispose() {
    _girthCtrl.dispose();
    _lengthCtrl.dispose();
    super.dispose();
  }

  // ---------- Helpers ----------
  double _toCm(double v, bool useMetric) => useMetric ? v : v * 2.54;

  // ignore: unused_element
  String _whereTitle(HorseMethod m) {
    switch (m) {
      case HorseMethod.adultPoint:
        return 'Where to measure — Adult (Point)';
      case HorseMethod.adultStifle:
        return 'Where to measure — Adult (Stifle)';
      case HorseMethod.yearling:
        return 'Where to measure — Yearling';
      case HorseMethod.foal:
        return 'Where to measure — Foal';
    }
  }

  // ---------- Formulas (inputs in cm, output kg) ----------
  // Adult (both point & stifle) use the same cm-divider 11877
  double _adultKg(double gCm, double lCm) => (gCm * gCm * lCm) / 11877.0;

  // Yearling (inches path uses 301 divisor; convert to kg)
  double _yearlingKg(double gCm, double lCm) {
    final gIn = gCm / 2.54, lIn = lCm / 2.54;
    final lbs = (gIn * gIn * lIn) / 301.0;
    return lbs / 2.2046226218;
  }

  // Foal (inches path uses 280 divisor; convert to kg)
  double _foalKg(double gCm, double lCm) {
    final gIn = gCm / 2.54, lIn = lCm / 2.54;
    final lbs = (gIn * gIn * lIn) / 280.0;
    return lbs / 2.2046226218;
  }

  double _errorBandFor(HorseMethod m, double estKg) {
    switch (m) {
      case HorseMethod.adultPoint:
        return 17.0; // ±17 kg band
      case HorseMethod.adultStifle:
        return 45.0; // wider band
      case HorseMethod.yearling:
        return math.max(15.0, estKg * 0.06);
      case HorseMethod.foal:
        return math.max(10.0, estKg * 0.08);
    }
  }

  void _calculate(bool useMetric) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final gRaw = double.parse(_girthCtrl.text.replaceAll(',', '.'));
    final lRaw = double.parse(_lengthCtrl.text.replaceAll(',', '.'));

    // Convert entered numbers to cm if the user is in imperial
    final gCm = _toCm(gRaw, useMetric);
    final lCm = _toCm(lRaw, useMetric);

    double kg;
    switch (_method) {
      case HorseMethod.adultPoint:
      case HorseMethod.adultStifle:
        kg = _adultKg(gCm, lCm);
        break;
      case HorseMethod.yearling:
        kg = _yearlingKg(gCm, lCm);
        break;
      case HorseMethod.foal:
        kg = _foalKg(gCm, lCm);
        break;
    }

    setState(() {
      _resultKg = kg;
      _errorBandKg = _errorBandFor(_method, kg);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Global units (same as cows)
    final units = context.watch<UnitSettings>();
    final useMetric = units.useMetric;

    // Neutral inputs like cows (no green focus)
    final base = Theme.of(context);
    final neutralInput = base.inputDecorationTheme.copyWith(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: base.colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: base.colorScheme.outline),
      ),
    );

    return Theme(
      data: base.copyWith(inputDecorationTheme: neutralInput),
      child: Scaffold(
        appBar: AppBar(centerTitle: false, title: Text(widget.title)),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Where-to-measure (plain card, left-aligned)
                Card(
                  color: base.colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title set below in a separate widget if you prefer dynamic text.
                        // For simplicity we keep static bullet guidance here.
                        // The method name appears in the AppBar title already.
                        Text(
                          'Where to measure — Adult (Point)',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Heart girth: just behind withers & elbows, tape level and snug.\n'
                          '• Body length (Point): point of shoulder → point of buttock.\n'
                          '• Body length (Stifle): point of shoulder → midpoint of stifle/tail fold.\n'
                          '• Stand square on level ground.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Form (labels include units, like cows)
                Card(
                  color: base.colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _MeasurementField(
                            controller: _girthCtrl,
                            label: useMetric ? 'Heart Girth (cm)' : 'Heart Girth (in)',
                            helper: 'Wrap tape just behind withers & elbows, level and snug.',
                          ),
                          const SizedBox(height: 12),
                          _MeasurementField(
                            controller: _lengthCtrl,
                            label: useMetric ? 'Body Length (cm)' : 'Body Length (in)',
                            helper: _method == HorseMethod.adultStifle
                                ? 'Point of shoulder → midpoint of stifle/tail fold (Stifle).'
                                : 'Point of shoulder → point of buttock (tuber ischii).',
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _calculate(useMetric),
                              child: const Text('Estimate Weight'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // RESULT — display in user’s unit system (kg or lb), like cows
                if (_resultKg != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Builder(
                      builder: (context) {
                        final displayWeight = units.metricWeightToUi(_resultKg!);
                        final weightLabel = Units.weightLabel(units.system);
                        final displayErr = _errorBandKg != null
                            ? units.metricWeightToUi(_errorBandKg!)
                            : null;

                        return Text(
                          'Estimated Weight: ${displayWeight.toStringAsFixed(2)} $weightLabel'
                          '${displayErr != null ? '  (±${displayErr.toStringAsFixed(1)} $weightLabel)' : ''}',
                          style: base.textTheme.titleMedium,
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),
                const _TipsPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- Widgets ----------
class _MeasurementField extends StatelessWidget {
  const _MeasurementField({
    required this.controller,
    required this.label,
    this.helper,
  });

  final TextEditingController controller;
  final String label;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        final p = double.tryParse(v.replaceAll(',', '.'));
        if (p == null) return 'Enter a number';
        if (p <= 0) return 'Must be greater than 0';
        return null;
      },
    );
  }
}

class _TipsPanel extends StatelessWidget {
  const _TipsPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const tips = [
      'Use a soft, flexible tape and keep it level.',
      'Have a handler keep the horse standing square on level ground.',
      'Measure twice and average if needed.',
      'Record and track measurements over time.',
    ];
    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tips for better accuracy', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...tips.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(t)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
