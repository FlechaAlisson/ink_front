import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/auth/model/user_model.dart';
import 'package:ink_front/features/home/bloc/home_event.dart';
import 'package:ink_front/features/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  UserModel user;
  HomeBloc({required this.user}) : super(HomeState());
}
