// File: lib/bloc/DashboardEvent.dart

import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class CreateInstitutionEvent extends DashboardEvent {
  final String name;
  final String address;
  final String phone;
  final String email;
  final String website;

  const CreateInstitutionEvent({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
  });

  @override
  List<Object> get props => [name, address, phone, email, website];
}

class FetchInstitutionsEvent extends DashboardEvent {
  const FetchInstitutionsEvent();

  @override
  List<Object> get props => [];
}

class UpdateTokenEvent extends DashboardEvent {
  final String token;

  const UpdateTokenEvent({required this.token});

  @override
  List<Object> get props => [token];
}
