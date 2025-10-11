import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'controller/auth_controller.dart';
import 'view/auth/login_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

// PROVIDER GLOBAL PARA OS CONTROLLERS
class AppState extends InheritedWidget {
  final AuthController authController;

  const AppState({
    super.key,
    required super.child,
    required this.authController,
  });

  static AppState of(BuildContext context) {
    final AppState? result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No AppState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return true;
  }
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return AppState(
      authController: _authController,
      child: MaterialApp(
        title: 'TEApoio Chat',
        theme: ThemeData(
          primaryColor: const Color(0xFFB59DD9),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}