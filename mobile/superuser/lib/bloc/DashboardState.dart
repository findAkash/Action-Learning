// File: lib/bloc/dashboard_state.dart

import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class InstitutionCreationLoading extends DashboardState {}

class InstitutionCreationSuccess extends DashboardState {}

class InstitutionCreationFailure extends DashboardState {
  final String error;

  const InstitutionCreationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class InstitutionsFetchLoading extends DashboardState {}

class InstitutionsFetchSuccess extends DashboardState {
  final List<Map<String, dynamic>> institutions;

  const InstitutionsFetchSuccess({required this.institutions});

  @override
  List<Object> get props => [institutions];
}

class InstitutionsFetchFailure extends DashboardState {
  final String error;

  const InstitutionsFetchFailure({required this.error});

  @override
  List<Object> get props => [error];
}
