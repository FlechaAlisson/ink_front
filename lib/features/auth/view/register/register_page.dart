import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ink_front/shared/app_colors.dart';
import 'package:ink_front/shared/widgets/bottom_sheet.dart';
import 'package:ink_front/shared/widgets/page.dart';
import 'package:ink_front/shared/widgets/text_input.dart';
import 'package:ink_front/features/auth/bloc/register/register_bloc.dart';
import 'package:ink_front/features/auth/bloc/register/register_event.dart';
import 'package:ink_front/features/auth/bloc/register/register_state.dart';
import 'package:ink_front/features/auth/data/repositories/auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(context.read<AuthRepository>()),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.status == RegisterStatus.success) {
            showCustomBottomSheet(
              context,
              message: 'Registro realizado com sucesso!',
              buttonLabel: 'Logar',
              isDismissible: false,
              onButtonPressed: () {
                final bloc = context.read<RegisterBloc>();
                context.pop();
                context.pop({
                  'email': bloc.emailController.text,
                  'password': bloc.passwordController.text,
                });
              },
            );
          } else if (state.status == RegisterStatus.failure) {
            showCustomBottomSheet(
              context,
              type: BottomsheetType.error,
              message: state.errorMessage ?? 'Erro ao registrar usuário.',
              buttonLabel: 'Tentar novamente',
              onButtonPressed: () => context.pop(),
            );
          }
        },
        child: CustomPage(child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
          final bloc = context.read<RegisterBloc>();
          return Column(
            children: [
              const SizedBox(height: 40),

              // TÍTULO
              const Text(
                "Criar Conta",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 32),

              // FORM
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextInput(
                      label: "Nome",
                      hint: "Seu nome completo",
                      controller: bloc.nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? "Digite seu nome"
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextInput(
                      label: "Telefone",
                      hint: "Ex: (99) 99999-9999",
                      controller: bloc.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    CustomTextInput(
                      label: "Email",
                      hint: "email@exemplo.com",
                      controller: bloc.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value == null || !value.contains("@")
                              ? "Email inválido"
                              : null,
                    ),
                    const SizedBox(height: 20),
                    CustomTextInput(
                      label: "Senha",
                      hint: "Escolha uma senha",
                      controller: bloc.passwordController,
                      obscureText: obscurePassword,
                      validator: (value) => value != null && value.length >= 6
                          ? null
                          : "Mínimo 6 caracteres",
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() => obscurePassword = !obscurePassword);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // BOTÃO REGISTRAR
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: bloc.state.status == RegisterStatus.loading
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            bloc.add(
                              RegisterSubmitted(
                                email: bloc.emailController.text,
                                password: bloc.passwordController.text,
                                name: bloc.nameController.text,
                                phone: bloc.phoneController.text,
                              ),
                            );
                          }
                        },
                  child: bloc.state.status == RegisterStatus.loading
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : const Text(
                          "Registrar",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => context.pop(),
                child: const Text(
                  "Já tenho uma conta",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          );
        })),
      ),
    );
  }
}
