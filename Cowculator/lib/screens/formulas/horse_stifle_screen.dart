import 'package:flutter/material.dart';
import 'horse_weight_screen.dart';

class HorseStifleScreen extends StatelessWidget {
  const HorseStifleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HorseWeightScreen(
      fixedMethod: HorseMethod.adultStifle,
      title: 'Horse — Adult (Stifle) Formula',
      // useMetric: true, // <- (Optional) pass your global units here
    );
  }
}
