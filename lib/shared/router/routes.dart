import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ink_front/features/appointments/bloc/list_appointment/list_appointment_bloc.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_bloc.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_event.dart';
import 'package:ink_front/features/appointments/data/appointment_repository.dart';
import 'package:ink_front/features/appointments/view/list_appointment_page.dart';
import 'package:ink_front/features/appointments/view/selection_appointment.dart';
import 'package:ink_front/features/auth/bloc/auth/auth_bloc.dart';
import 'package:ink_front/features/auth/bloc/login/login_bloc.dart';
import 'package:ink_front/features/auth/bloc/register/register_bloc.dart';
import 'package:ink_front/features/auth/data/repositories/auth_repository.dart';
import 'package:ink_front/features/auth/view/login/login_page.dart';
import 'package:ink_front/features/auth/view/register/register_page.dart';
import 'package:ink_front/features/home/bloc/home_bloc.dart';
import 'package:ink_front/features/home/view/home.dart';

enum AppRoute {
  login('/', 'login'),
  register('/register', 'register'),
  home('/home', 'home'),
  selectionAppointment('/selection-appointment', 'selection-appointment'),
  listAppointement('/list-appointment', 'list-appointment');

  final String path;
  final String name;

  const AppRoute(this.path, this.name);
}

abstract class CustomRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        name: AppRoute.login.name,
        path: AppRoute.login.path,
        builder: (context, state) => BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
            context.read<AuthRepository>(),
            context.read<AuthBloc>(),
          ),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        name: AppRoute.register.name,
        path: AppRoute.register.path,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => RegisterBloc(
              context.read<AuthRepository>(),
            ),
            child: const RegisterPage(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.listAppointement.name,
        path: AppRoute.listAppointement.path,
        builder: (context, state) {
          final authRepo = context.read<AuthRepository>();

          return BlocProvider(
            create: (_) => ListAppointmentBloc(
              AppointmentRepository(authRepo),
            ),
            child: const AppointmentsListScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.selectionAppointment.name,
        path: AppRoute.selectionAppointment.path,
        builder: (context, state) {
          final authRepo = context.read<AuthRepository>();

          return BlocProvider(
            create: (_) {
              return SelectionAppointmentBloc(
                AppointmentRepository(authRepo),
              )..add(LoadTimeSlots(
                  DateTime.now().toIso8601String().split('T')[0]));
            },
            child: const AppointmentBookingScreen(),
          );
        },
      ),
      GoRoute(
        name: AppRoute.home.name,
        path: AppRoute.home.path,
        builder: (context, state) {
          final AuthBloc authBloc = context.read<AuthBloc>();

          return BlocProvider(
            create: (_) => HomeBloc(
              user: authBloc.state.user!,
            ),
            child: const HomePage(),
          );
        },
      ),
    ],
  );
}
