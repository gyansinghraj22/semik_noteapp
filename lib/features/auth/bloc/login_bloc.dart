import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:noteapp/core/common/error_model/error_model.dart';
import 'package:noteapp/features/auth/bloc/login_state.dart';
import 'package:noteapp/features/auth/services/login_service.dart';

import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    final loginService = GetIt.instance.get<LoginService>();

    on<LoginEvent>((event, emit) async {
      if (event is LoginInitialEvent) {
        emit(LoginInitialState());
      } else if (event is UserLoginEvent) {
        var result = await loginService.login(formData: event.formData);
        result.fold(
          (l) {
            emit(UserLoginSuccessState(response: l));
          },
          (r) {
            emit(
              UserLoginErrorState(
                error: ErrorModel(code: r.code, message: r.message),
              ),
            );
          },
        );
      }
    });
  }
}
