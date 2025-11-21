import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Importar o Core
import 'controller/auth_controller.dart';
import 'view/auth/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  // 2. Garantir que os widgets do Flutter estejam prontos antes de iniciar o Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inicializar o Firebase (sem opções, pois você já tem o google-services.json)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

// ... O restante do arquivo continua igual ...
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