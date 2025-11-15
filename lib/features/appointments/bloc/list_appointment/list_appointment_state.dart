import 'package:equatable/equatable.dart';
import 'package:ink_front/features/appointments/model/appointment_model.dart';

enum ListAppointmentStatus {
  initial,
  loading,
  success,
  failure,
}

class ListAppointmentState extends Equatable {
  final ListAppointmentStatus status;
  final List<AppointmentModel> appointments;
  final String? errorMessage;

  const ListAppointmentState({
    this.status = ListAppointmentStatus.initial,
    this.appointments = const [],
    this.errorMessage,
  });

  ListAppointmentState copyWith({
    ListAppointmentStatus? status,
    List<AppointmentModel>? appointments,
    String? errorMessage,
  }) {
    return ListAppointmentState(
      status: status ?? this.status,
      appointments: appointments ?? this.appointments,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        appointments,
        errorMessage,
      ];
}
