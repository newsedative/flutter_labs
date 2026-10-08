import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/features/tasks/models/task_item.dart';
import 'package:flutter_application_1/app/features/tasks/screens/task_details_page.dart';
import 'package:flutter_application_1/app/features/tasks/screens/tasks_home_page.dart';

abstract final class AppRouter {
  static const home = '/';
  static const taskDetails = '/task-details';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const TasksHomePage(),
          settings: settings,
        );
      case taskDetails:
        final task = settings.arguments;
        if (task is! TaskItem) {
          throw FlutterError(
            'The $taskDetails route requires a TaskItem argument.',
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => TaskDetailsPage(task: task),
          settings: settings,
        );
      default:
        throw FlutterError('No route defined for ${settings.name}.');
    }
  }
}
