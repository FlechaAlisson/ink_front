import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/auth/bloc/auth/auth_bloc.dart';
import 'package:ink_front/features/auth/bloc/auth/auth_event.dart';
import 'package:ink_front/features/auth/bloc/login/login_event.dart';
import 'package:ink_front/features/auth/bloc/login/login_state.dart';
import 'package:ink_front/features/auth/data/repositories/auth_repository.dart';
import 'package:ink_front/features/auth/model/user_model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;
  final AuthBloc authBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  UserModel? user;

  LoginBloc(
    this.repository,
    this.authBloc,
  ) : super(LoginState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      user = await repository.login(
        email: event.email,
        password: event.password,
      );

      authBloc.add(AuthLoginSuccess(user!));

      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LoginState> emit,
  ) async {
    // await repository.logout();
    emit(state.copyWith(status: LoginStatus.initial));
  }
}
