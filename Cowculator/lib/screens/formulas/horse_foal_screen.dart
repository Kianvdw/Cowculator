import 'package:flutter/material.dart';
import 'horse_weight_screen.dart';

class HorseFoalScreen extends StatelessWidget {
  const HorseFoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HorseWeightScreen(
      fixedMethod: HorseMethod.foal,
      title: 'Horse — Foal Formula',
      // useMetric: true, // <- (Optional) pass your global units here
    );
  }
}
