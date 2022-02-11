import 'package:flutter/material.dart';
import './login.dart';
import './launcher.dart';
import 'screens/mainscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LauncherPage(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => const LoginPage(),
          '/landing': (BuildContext context) => const MainScreen(),
        });
  }
}
