import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'units.dart';

class UnitSettings extends ChangeNotifier {
  static const _key = "unit_system";
  UnitSystem _system = UnitSystem.metric;

  UnitSettings() {
    _load();
  }

  // Existing API (kept)
  UnitSystem get system => _system;
  bool get isMetric => _system == UnitSystem.metric;

  // ✅ Added: unified getters/setters used across the app
  UnitSystem get unitSystem => _system;                 // alias for consistency
  bool get useMetric => _system == UnitSystem.metric;   // what horse screens read

  set system(UnitSystem s) {
    if (_system != s) {
      _system = s;
      _save();
      notifyListeners();
    }
  }

  // ✅ Added: convenience setter & toggle (optional but handy)
  void setUseMetric(bool value) =>
      system = value ? UnitSystem.metric : UnitSystem.imperial;

  void toggle() =>
      system = (useMetric ? UnitSystem.imperial : UnitSystem.metric);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_key);
    if (v == "imperial") _system = UnitSystem.imperial;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, _system == UnitSystem.metric ? "metric" : "imperial");
  }

  // UI --> metric (for calculations)
  double uiLengthToMetric(double value) => isMetric ? value : Units.inToCm(value);
  double uiWeightToMetric(double value) => isMetric ? value : Units.lbToKg(value);

  // metric --> UI (for display)
  double metricLengthToUi(double cm) => isMetric ? cm : Units.cmToIn(cm);
  double metricWeightToUi(double kg) => isMetric ? kg : Units.kgToLb(kg);
}
