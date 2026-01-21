import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme/theme.dart';
import 'screens/landing_screen.dart';
import 'screens/ritual_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize flutter_animate properly for web
  Animate.restartOnHotReload = true;
  
  // Skip system UI overlay on web
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.surfaceDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }
  
  runApp(const AnimeConnesseApp());
}

class AnimeConnesseApp extends StatelessWidget {
  const AnimeConnesseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiger & Quokka',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppNavigator(),
    );
  }
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  bool _hasEntered = false;

  void _enterApp() {
    setState(() {
      _hasEntered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _hasEntered
          ? const RitualDashboardScreen(key: ValueKey('dashboard'))
          : LandingScreen(
              key: const ValueKey('landing'),
              onEnter: _enterApp,
            ),
    );
  }
}