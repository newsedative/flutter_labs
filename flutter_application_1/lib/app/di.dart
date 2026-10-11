import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'data/dio/set_up.dart';
import 'features/tasks/bloc/home_bloc.dart';
import 'features/tasks/repositories/content_repository.dart';
import 'features/tasks/repositories/content_repository_interface.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final Dio dio = Dio();
  setUpDio(dio);

  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<ContentRepositoryInterface>(
    ContentRepository(dio: dio),
  );
  getIt.registerSingleton<HomeBloc>(
    HomeBloc(getIt<ContentRepositoryInterface>()),
  );
}
