import 'package:flutter/material.dart';
import 'package:noteapp/core/common/error_model/error_model.dart';

@immutable
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class UserLoginSuccessState extends LoginState {
  final dynamic response;
  UserLoginSuccessState({required this.response});
}

class UserLoginErrorState extends LoginState {
  final ErrorModel error;
  UserLoginErrorState({required this.error});
}
