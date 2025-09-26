import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_input_field.dart';
import '../main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textPrimary,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainPage()));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.error));
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    spacing: AppSpacing.md,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.surface),
                      ),
                      Text(
                        'Login Here',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.surface),
                      ),
                    ],
                  ),
                ),

                Form(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSpacing.xxl),
                        topRight: Radius.circular(AppSpacing.xxl),
                      ),
                      color: AppColors.surface,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Login Icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.login, size: 40, color: AppColors.primary),
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Username Field
                        CustomInputField(
                          label: 'Username',
                          hint: 'please enter your username',
                          controller: _usernameController,
                          prefixIcon: const Icon(Icons.person_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Password Field
                        CustomInputField(
                          label: 'Password',
                          hint: 'please enter your password',
                          controller: _passwordController,
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outline),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),

                        // Login Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: 'Login',
                              isLoading: state is AuthLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    LoginRequested(
                                      username: _usernameController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Register Link
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("don't have an account?", style: TextStyle(color: AppColors.textSecondary)),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
                              },
                              child: const Text(
                                'register',
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
