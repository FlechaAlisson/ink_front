import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_event.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_state.dart';
import 'package:ink_front/features/appointments/data/appointment_repository.dart';
import 'package:ink_front/features/appointments/model/time_slot_model.dart';

class SelectionAppointmentBloc
    extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository repository;
  final TextEditingController dateController = TextEditingController(
      text: DateTime.now()
          .toIso8601String()
          .split('T')[0]
          .split('-')
          .reversed
          .join('/'));

  SelectionAppointmentBloc(this.repository) : super(const AppointmentState()) {
    on<LoadTimeSlots>(_onLoadTimeSlots);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<BookAppointment>(_onBookAppointment);
  }

  Future<void> _onLoadTimeSlots(
    LoadTimeSlots event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(
      status: AppointmentStatus.loading,
      selectedDate: event.date,
    ));

    try {
      final List<TimeSlot> availableSlots =
          await repository.getTimeSlots(event.date);

      emit(state.copyWith(
        status: AppointmentStatus.success,
        timeSlot: availableSlots, // Extrai apenas a lista de TimeSlot
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppointmentStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectTimeSlot(
    SelectTimeSlot event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(
      selectedTimeSlot: event.timeSlot,
    ));
  }

  Future<void> _onBookAppointment(
    BookAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(status: AppointmentStatus.loading));

    try {
      final result = await repository.bookAppointment(
        date: event.date,
        startAt: event.startAt,
      );

      emit(state.copyWith(
        status: AppointmentStatus.booked,
        bookingId: result['id'],
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AppointmentStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
