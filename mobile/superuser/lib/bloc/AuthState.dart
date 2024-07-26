// File: bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';





abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;

  const AuthSuccess({required this.token});

  @override
  List<Object> get props => [token];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}
