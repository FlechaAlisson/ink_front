import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ink_front/shared/app_colors.dart';
import 'package:ink_front/shared/router/routes.dart';
import 'package:ink_front/shared/widgets/buttons.dart';
import 'package:ink_front/shared/widgets/page.dart';
import 'package:ink_front/shared/widgets/text_input.dart';
import 'package:ink_front/features/auth/bloc/login/login_bloc.dart';
import 'package:ink_front/features/auth/bloc/login/login_event.dart';
import 'package:ink_front/features/auth/bloc/login/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          context.go(AppRoute.home.path);
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Erro ao fazer login'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final bloc = context.read<LoginBloc>();

          return CustomPage(
            child: Column(
              children: [
                Expanded(child: Container()),
                Center(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 80),
                CustomTextInput(
                    label: 'Email', controller: bloc.emailController),
                SizedBox(height: 20),
                CustomTextInput(
                  label: 'Senha',
                  controller: bloc.passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 32),
                // Mostra loading ou botão
                state.status == LoginStatus.loading
                    ? CircularProgressIndicator()
                    : CustomButton.primary(
                        title: 'Entrar',
                        onPressed: () {
                          bloc.add(
                            LoginRequested(
                              bloc.emailController.text,
                              bloc.passwordController.text,
                            ),
                          );
                        },
                      ),
                SizedBox(height: 4),
                _orSection(),
                SizedBox(height: 4),
                CustomButton.secondary(
                  title: 'Registrar',
                  onPressed: () async {
                    final result = await context.push(AppRoute.register.path);

                    // Verifica se recebeu dados
                    if (result != null && result is Map<String, String>) {
                      // ignore: use_build_context_synchronously
                      final bloc = context.read<LoginBloc>();
                      bloc.emailController.text = result['email'] ?? '';
                      bloc.passwordController.text = result['password'] ?? '';
                    }
                  },
                ),
                Expanded(child: Container()),
              ],
            ),
          );
        },
      ),
    );
  }

  Row _orSection() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
        Text(
          ' OU ',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ],
    );
  }
}
