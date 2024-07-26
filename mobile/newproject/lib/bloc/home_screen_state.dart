part of 'home_screen_bloc.dart';



abstract class HomeScreenState extends Equatable {
  const HomeScreenState();
}

class HomeLoadingState extends HomeScreenState {
  @override
  List<Object> get props => [];
}

class HomeLoadedState extends HomeScreenState {
  @override
  final Activity activityObject;
  HomeLoadedState(this.activityObject);
  List<Object?> get props => [activityObject];
}

class HomeNoInternetState extends HomeScreenState {
  @override
  List<Object?> get props => [];
}
