import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/appointments/bloc/list_appointment/list_appointment_event.dart';
import 'package:ink_front/features/appointments/bloc/list_appointment/list_appointment_state.dart';
import 'package:ink_front/features/appointments/data/appointment_repository.dart';

class ListAppointmentBloc
    extends Bloc<ListAppointmentEvent, ListAppointmentState> {
  final AppointmentRepository repository;

  ListAppointmentBloc(this.repository) : super(const ListAppointmentState()) {
    on<LoadAppointments>(_onLoadAppointments);

    add(LoadAppointments());
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<ListAppointmentState> emit,
  ) async {
    emit(state.copyWith(status: ListAppointmentStatus.loading));

    try {
      final list = await repository.getAppointments();

      emit(
        state.copyWith(
          status: ListAppointmentStatus.success,
          appointments: list,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ListAppointmentStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
