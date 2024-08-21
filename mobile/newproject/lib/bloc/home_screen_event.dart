part of 'home_screen_bloc.dart';



abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();
}

class LoadApiEvent extends HomeScreenEvent {
  @override
  List<Object> get props => [];
}

class NoInternetEvent extends HomeScreenEvent {
  @override
  List<Object> get props => [];
}
