import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ink_front/features/home/bloc/home_bloc.dart';

import 'package:ink_front/shared/app_colors.dart';
import 'package:ink_front/shared/router/routes.dart';
import 'package:ink_front/shared/widgets/page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<HomeBloc>().user;
    return CustomPage(
      backgroundColor: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Home',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Olá, ${user.name}',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Botão grande "Agendar"
          SizedBox(
            height: 100,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              onPressed: () =>
                  context.pushNamed(AppRoute.selectionAppointment.name),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Agendar',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.assignment_add,
                    size: 32,
                    color: AppColors.primary,
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Linhas dos dois botões menores
          Row(
            children: [
              // Meus Agendamentos
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      context.pushNamed(AppRoute.listAppointement.name),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Meus\nAgendamentos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.assignment_turned_in_outlined,
                          size: 32,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Sugestões
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sugestões',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 24),
                      Icon(
                        Icons.lightbulb_outlined,
                        size: 32,
                        color: AppColors.secondary,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
