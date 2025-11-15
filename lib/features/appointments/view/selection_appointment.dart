import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_bloc.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_event.dart';
import 'package:ink_front/features/appointments/bloc/selection_appointment/selection_appointment_state.dart';
import 'package:ink_front/shared/app_colors.dart';
import 'package:ink_front/shared/widgets/buttons.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  @override
  void dispose() {
    // _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectionAppointmentBloc, AppointmentState>(
      listener: (context, state) {
        if (state.status == AppointmentStatus.booked) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Agendamento confirmado com sucesso!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<SelectionAppointmentBloc, AppointmentState>(
            builder: (context, state) {
          final bloc = context.read<SelectionAppointmentBloc>();
          // --- LOADING ---
          if (state.status == AppointmentStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // --- EMPTY OR NULL TIMESLOT ---
          if (state.timeSlot == null || state.timeSlot!.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum horário disponível',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campo Data
                  const Text(
                    'Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: bloc.dateController,
                    readOnly: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.surfaceAccent,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.surfaceAccent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2026),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primary,
                                onPrimary: AppColors.white,
                                surface: AppColors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        bloc.dateController.text =
                            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                  // Horários
                  const Text(
                    'Horário',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: state.timeSlot!.map((time) {
                        final isSelected = time == state.selectedTimeSlot;
                        return InkWell(
                          onTap: () {
                            context
                                .read<SelectionAppointmentBloc>()
                                .add(SelectTimeSlot(time));
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: time.available
                                  ? isSelected
                                      ? AppColors.secondary
                                      : AppColors.surfaceVariant
                                  : AppColors.textDisabled,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                time.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Botão Confirmar
                  CustomButton.primary(
                    title: 'Confirmar',
                    onPressed: () {
                      final date = bloc.dateController.text
                          .split('/')
                          .reversed
                          .join('-');
                      final time = state.selectedTimeSlot?.startAt;

                      if (time == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Selecione um horário.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      context.read<SelectionAppointmentBloc>().add(
                            BookAppointment(
                              date: date,
                              startAt: time,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
