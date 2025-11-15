import 'package:ink_front/features/auth/model/user_model.dart';

abstract class AuthEvent {}

class AuthLoginSuccess extends AuthEvent {
  final UserModel user;
  AuthLoginSuccess(this.user);
}

class AuthLogout extends AuthEvent {}
