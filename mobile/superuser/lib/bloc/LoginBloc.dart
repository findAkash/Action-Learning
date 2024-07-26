// File: lib/bloc/login_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'LoginEvent.dart';
import 'LoginState.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/v1/superadmin/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': event.email, 'password': event.password}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            emit(LoginSuccess(token: data['user']['tokens']['token']));
          } else {
            emit(LoginFailure(error: 'Login failed: Success is not true'));
          }
        } else {
          emit(LoginFailure(error: 'Failed to login: ${response.statusCode}'));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
