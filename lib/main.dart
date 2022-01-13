import 'package:flurobenu/navigate_mode.dart';
import 'package:flurobenu/router/route_logging_observer.dart';
import 'package:flurobenu/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  navigateMode = NavigateMode.withContext;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'flurobenu Demo: navigate with context (without using navigator key)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      navigatorObservers: [RouteLoggingObserver()],
      home: const SplashScreen(),
    );
  }
}
