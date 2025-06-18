import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login/login_controller.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/registro/registro_screen.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() {
  Gemini.init(
    apiKey: 'AIzaSyBil1A_xmCzt5Q-XF5J3KcAFgyN0qOaDZs',
  ); // Reemplaza con tu clave de API de Gemini
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginController())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatiFy',
        theme: ThemeData.dark(),
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          '/home': (_) => const HomeScreen(),
          '/registro': (_) => const RegistroScreen(),
        },
      ),
    );
  }
}
