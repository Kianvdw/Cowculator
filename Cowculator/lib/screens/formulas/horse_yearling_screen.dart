import 'package:flutter/material.dart';
import 'horse_weight_screen.dart';

class HorseYearlingScreen extends StatelessWidget {
  const HorseYearlingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HorseWeightScreen(
      fixedMethod: HorseMethod.yearling,
      title: 'Horse — Yearling Formula',
      // useMetric: true, // <- (Optional) pass your global units here
    );
  }
}
