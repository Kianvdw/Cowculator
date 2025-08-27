enum UnitSystem { metric, imperial }

class Units {
  // --- Length ---
  static double cmToIn(double cm) => cm / 2.54;
  static double inToCm(double inches) => inches * 2.54;

  // --- Weight ---
  static double kgToLb(double kg) => kg * 2.20462262185;
  static double lbToKg(double lb) => lb / 2.20462262185;

  static String lengthLabel(UnitSystem u) => u == UnitSystem.metric ? "cm" : "in";
  static String weightLabel(UnitSystem u) => u == UnitSystem.metric ? "kg" : "lb";
}
