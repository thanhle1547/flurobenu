import 'package:flurobenu/navigate_mode.dart';
import 'package:flurobenu/router/app_pages.dart';
import 'package:flurobenu/router/app_router.dart';
import 'package:flurobenu/router/route_logging_observer.dart';
import 'package:flurobenu/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'router/routes.dart';

void main() {
  navigateMode = NavigateMode.withContext;
  AppRouter.setDefaultConfig(
    initialPage: AppPages.Initial,
    routes: routes,
    routeNameBuilder: (page) => (page as AppPages).name,
  );
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
      // initialRoute: AppPages.Post_Published.name,
      home: const SplashScreen(),
    );
  }
}
