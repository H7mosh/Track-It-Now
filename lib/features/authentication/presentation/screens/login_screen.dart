import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../cubit/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameUserController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameUserController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        _nameUserController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, textDirection: TextDirection.rtl),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingIndicator(
              message: 'چاوەڕوانبە...',
              fullScreen: true,
            );
          }

          return Center(
            child: SingleChildScrollView(
              child: Container(
                width: isSmallScreen ? size.width * 0.9 : 400,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App Logo or Title
                      const Icon(
                        Icons.location_on,
                        size: 64,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'تڕاک ئیت ناو',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 32),

                      // Username field
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CustomTextField(
                          label: 'ناوی بەکارهێنەر',
                          hint: 'ناوی بەکارهێنەر بنووسە',
                          controller: _nameUserController,
                          prefixIcon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تکایە ناوی بەکارهێنەر بنووسە';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Password field
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: CustomTextField(
                          label: 'وشەی نهێنی',
                          hint: 'وشەی نهێنی بنووسە',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock,
                          suffixIcon: _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          onSuffixIconPressed: _togglePasswordVisibility,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تکایە وشەی نهێنی بنووسە';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login button
                      CustomButton(
                        text: 'چوونەژوورەوە',
                        onPressed: _submit,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}