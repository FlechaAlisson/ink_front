import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ink_front/features/appointments/bloc/list_appointment/list_appointment_bloc.dart';
import 'package:ink_front/features/appointments/bloc/list_appointment/list_appointment_state.dart';
import 'package:ink_front/shared/app_colors.dart';
import 'package:ink_front/shared/widgets/page.dart';

class AppointmentsListScreen extends StatelessWidget {
  const AppointmentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      title: "Agendamentos",
      padding: const EdgeInsets.all(24),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      child: BlocBuilder<ListAppointmentBloc, ListAppointmentState>(
        builder: (context, state) {
          // LOADING
          if (state.status == ListAppointmentStatus.loading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            );
          }

          // ERRO
          if (state.status == ListAppointmentStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Text(
                  state.errorMessage ?? "Erro ao carregar agendamentos",
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // LISTA VAZIA
          if (state.appointments.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: Text(
                  "Nenhum agendamento encontrado",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // LISTA — usando Column (compatível com IntrinsicHeight)
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Agendamentos',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // --- LISTA CORRIGIDA ---
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final appointment in state.appointments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                appointment.getFormattedDateTime(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Reservado',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
