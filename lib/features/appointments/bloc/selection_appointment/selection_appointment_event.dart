import 'package:equatable/equatable.dart';
import 'package:ink_front/features/appointments/model/time_slot_model.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadTimeSlots extends AppointmentEvent {
  final String date;

  const LoadTimeSlots(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectTimeSlot extends AppointmentEvent {
  final TimeSlot timeSlot;

  const SelectTimeSlot(this.timeSlot);

  @override
  List<Object?> get props => [timeSlot];
}

class BookAppointment extends AppointmentEvent {
  final String date;
  final String startAt;

  const BookAppointment({
    required this.date,
    required this.startAt,
  });

  @override
  List<Object?> get props => [date, startAt];
}
