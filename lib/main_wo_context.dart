import 'package:flurobenu/navigate_mode.dart';
import 'package:flurobenu/router/app_pages.dart';
import 'package:flurobenu/router/app_router.dart';
import 'package:flurobenu/router/route_logging_observer.dart';
import 'package:flutter/material.dart';

void main() {
  navigateMode = NavigateMode.withoutContext;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flurobenu Demo: navigate without context',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      navigatorObservers: [RouteLoggingObserver()],
      // optional
      // initialRoute: AppPages.Initial.name,
      navigatorKey: AppRouter.createNavigatorKeyIfNotExisted(),
      // optional
      // onGenerateInitialRoutes: AppRouter.onGenerateInitialRoutes,
      onUnknownRoute: AppRouter.onUnknownRoute,
    );
  }
}
