import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/auth/bloc/register/register_event.dart';
import 'package:ink_front/features/auth/bloc/register/register_state.dart';
import 'package:ink_front/features/auth/data/repositories/auth_repository.dart';
import 'package:ink_front/features/auth/model/user_model.dart';
import 'package:ink_front/shared/others/custom_print.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repository;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RegisterBloc(this.repository) : super(RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null));

      final user = UserModel(
        uid: "", // o datasource irá substituir pelo uid do Firebase
        email: event.email,
        name: event.name,
        phone: event.phone,
        password: event.password,
      );

      await repository.registerUser(
        email: user.email,
        password: user.password,
        name: user.name,
        phone: user.phone,
      );

      emit(state.copyWith(status: RegisterStatus.success));
    } on FirebaseAuthException catch (e) {
      if (e.message ==
          'The email address is already in use by another account.') {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: 'Este e-mail já está em uso.',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: RegisterStatus.failure,
            errorMessage: e.message,
          ),
        );
      }
    } catch (e) {
      CustomPrint.call('Erro no registro: $e', level: LogLevel.error);
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
