import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'units.dart';

class UnitSettings extends ChangeNotifier {
  static const _key = "unit_system";
  UnitSystem _system = UnitSystem.metric;

  UnitSettings() {
    _load();
  }

  UnitSystem get system => _system;
  bool get isMetric => _system == UnitSystem.metric;

  set system(UnitSystem s) {
    if (_system != s) {
      _system = s;
      _save();
      notifyListeners();
    }
  }

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
