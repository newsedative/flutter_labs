import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/content.dart';
import '../repositories/content_repository_interface.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContentRepositoryInterface contentRepository;

  HomeBloc(this.contentRepository) : super(HomeInitial()) {
    on<HomeLoad>(_onHomeLoad);
  }

  Future<void> _onHomeLoad(HomeLoad event, Emitter<HomeState> emit) async {
    emit(HomeLoadInProgress());

    try {
      final content = await contentRepository.getContent();
      emit(HomeLoadSuccess(content: content));
    } catch (exception) {
      emit(HomeLoadFailure(exception: exception));
    }
  }
}
