import 'package:ink_front/features/auth/model/user_model.dart';

enum AuthStateEnum {
  initial,
  authenticated,
  unauthenticated,
}

class AuthState {
  AuthStateEnum state = AuthStateEnum.initial;
  UserModel? user;
  AuthState({
    this.state = AuthStateEnum.initial,
    this.user,
  });

  AuthState copyWith({
    AuthStateEnum? state,
    UserModel? user,
  }) {
    return AuthState(
      state: state ?? this.state,
      user: user ?? this.user,
    );
  }
}
