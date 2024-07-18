import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final String apiUrl;

  LoginBloc({required this.apiUrl}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    print('LoginLoading state emitted');

    try {
      print('Making API call to $apiUrl/api/v1/superadmin/auth/login');
      final response = await http
          .post(
            Uri.parse('$apiUrl/api/v1/superadmin/auth/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': event.email,
              'password': event.password,
            }),
          )
          .timeout(Duration(seconds: 10));
      ;

      print('API call made. Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        emit(LoginSuccess());
        print("LoginSuccess state emitted");
      } else {
        emit(LoginFailure(error: 'Login failed'));
        print("LoginFailure state emitted: ${response.body}");
      }
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
      print("LoginFailure state emitted: $error");
    }
  }
}
