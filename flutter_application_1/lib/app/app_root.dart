import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/router/app_router.dart';
import 'package:flutter_application_1/app/theme/app_theme.dart';

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
