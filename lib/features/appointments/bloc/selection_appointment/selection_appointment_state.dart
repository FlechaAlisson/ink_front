import 'package:equatable/equatable.dart';
// import 'package:ink_front/features/appointments/model/available_slots_model.dart';
import 'package:ink_front/features/appointments/model/time_slot_model.dart';

enum AppointmentStatus { initial, loading, success, failure, booking, booked }

class AppointmentState extends Equatable {
  final AppointmentStatus status;
  final String? errorMessage;
  final List<TimeSlot>? timeSlot;
  final TimeSlot? selectedTimeSlot;
  final String? selectedDate;
  final String? bookingId;

  const AppointmentState({
    this.status = AppointmentStatus.initial,
    this.errorMessage,
    this.timeSlot,
    this.selectedTimeSlot,
    this.selectedDate,
    this.bookingId,
  });

  AppointmentState copyWith({
    AppointmentStatus? status,
    String? errorMessage,
    List<TimeSlot>? timeSlot,
    TimeSlot? selectedTimeSlot,
    String? selectedDate,
    String? bookingId,
  }) {
    return AppointmentState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      timeSlot: timeSlot ?? this.timeSlot,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      selectedDate: selectedDate ?? this.selectedDate,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        timeSlot,
        selectedTimeSlot,
        selectedDate,
        bookingId,
      ];
}
