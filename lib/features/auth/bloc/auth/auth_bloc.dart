import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/auth/bloc/auth/auth_event.dart';
import 'package:ink_front/features/auth/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<AuthLoginSuccess>((event, emit) {
      emit(state.copyWith(
        state: AuthStateEnum.authenticated,
        user: event.user,
      ));
    });

    on<AuthLogout>((event, emit) {
      emit(state.copyWith(
        state: AuthStateEnum.unauthenticated,
        user: null,
      ));
    });
  }
}
