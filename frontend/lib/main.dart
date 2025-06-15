import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login/login_controller.dart';
import 'screens/login/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
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
        },
      ),
    );
  }
}
