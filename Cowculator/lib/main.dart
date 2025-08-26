import 'package:flutter/material.dart';
import 'screens/animal_selector_screen.dart';
// import 'screens/settings_screen.dart';

void main() {
  runApp(const CowculatorRoot());
}

class CowculatorRoot extends StatefulWidget {
  const CowculatorRoot({super.key});

  @override
  State<CowculatorRoot> createState() => _CowculatorRootState();
}

class _CowculatorRootState extends State<CowculatorRoot> {
  ThemeMode _themeMode = ThemeMode.system;

  void _updateTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return CowculatorApp(
      themeMode: _themeMode,
      onThemeChanged: _updateTheme,
    );
  }
}

class CowculatorApp extends StatelessWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeChanged;

  const CowculatorApp({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cowculator',
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: AnimalSelectorScreen(
        onThemeChanged: onThemeChanged,
        themeMode: themeMode,
      ),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.light,
        ).copyWith(
          surface: const Color(0xFFF5F5F5),
          surfaceContainerHighest: const Color(0xFFE0E0E0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE0E0E0),
          foregroundColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD6D6D6),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
        ).copyWith(
          surface: const Color(0xFF1A1A1A),
          surfaceContainerHighest: const Color(0xFF2C2C2C),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2A2A),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A3A3A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
        ),
      ),
    );
  }
}
