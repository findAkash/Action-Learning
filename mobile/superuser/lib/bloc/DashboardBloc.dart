// File: lib/bloc/DashboardBloc.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'DashboardEvent.dart';
import 'DashboardState.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  String token;

  DashboardBloc({required this.token}) : super(DashboardInitial()) {
    on<CreateInstitutionEvent>((event, emit) async {
      emit(InstitutionCreationLoading());

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/api/v1/superadmin/institution/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'name': event.name,
            'address': event.address,
            'phone': event.phone,
            'email': event.email,
            'website': event.website,
          }),
        );

        if (response.statusCode == 200) {
          emit(InstitutionCreationSuccess());
        } else {
          emit(InstitutionCreationFailure(error: 'Failed to create institution: ${response.statusCode}'));
        }
      } catch (e) {
        emit(InstitutionCreationFailure(error: e.toString()));
      }
    });

    on<FetchInstitutionsEvent>((event, emit) async {
      emit(InstitutionsFetchLoading());

      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:8000/api/v1/superadmin/institution/get'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            emit(InstitutionsFetchSuccess(institutions: List<Map<String, dynamic>>.from(data['institutions'])));
          } else {
            emit(InstitutionsFetchFailure(error: 'Failed to fetch institutions: Success is not true'));
          }
        } else {
          emit(InstitutionsFetchFailure(error: 'Failed to fetch institutions: ${response.statusCode}'));
        }
      } catch (e) {
        emit(InstitutionsFetchFailure(error: e.toString()));
      }
    });

    on<UpdateTokenEvent>((event, emit) {
      token = event.token;
    });
  }
}
