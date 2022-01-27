import 'package:flurobenu/router/app_pages.dart';
import 'package:flurobenu/router/app_router.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1200)).then((value) {
        AppRouter.replaceAllWithPage(
          context,
          AppPages.Post_Published,
          transition: Transition.fadeIn,
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 450),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
