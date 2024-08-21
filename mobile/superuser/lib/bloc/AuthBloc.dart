

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'AuthEvent.dart';
import 'AuthState.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthLoading();
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/v1/superadmin/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': event.email,
            'password': event.password,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            final token = data['user']['tokens']['token'];
            yield AuthSuccess(token: token);
          } else {
            yield AuthFailure(error: 'Login failed: Success is not true');
          }
        } else {
          yield AuthFailure(error: 'Failed to login: ${response.statusCode}');
        }
      } catch (e) {
        yield AuthFailure(error: e.toString());
      }
    }
  }
}
