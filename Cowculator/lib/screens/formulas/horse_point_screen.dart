import 'package:flutter/material.dart';
import 'horse_weight_screen.dart';

class HorsePointScreen extends StatelessWidget {
  const HorsePointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HorseWeightScreen(
      fixedMethod: HorseMethod.adultPoint,
      title: 'Horse — Adult (Point) Formula',
      // useMetric: true, // <- (Optional) pass your global units here
    );
  }
}
