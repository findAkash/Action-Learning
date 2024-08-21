import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../Model/Activity.dart';
import '../Networking/ActivityApi.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeLoadingState()) {
    on<LoadApiEvent>((event, emit) async {
      print('Emitting HomeLoadingState');
      emit(HomeLoadingState());
      try {
        final activityApi = ActivityApi();
        final activity = await activityApi.getActivity();
        await Future.delayed(Duration(seconds: 2)); // Simulate delay
        print('Emitting HomeLoadedState');
        emit(HomeLoadedState(activity));
      } catch (error) {
        print('Error: $error');
        emit(HomeNoInternetState());
      }
    });

    on<NoInternetEvent>((event, emit) {
      emit(HomeNoInternetState());
    });
  }
}
