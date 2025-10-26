import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/styles/text_field_styles.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const LoginForm({super.key, this.emailController, this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 7, left: 16, right: 16),
          child: TextField(
            controller: emailController,
            decoration: AppTextFieldStyle.defaultInputDecoration(
              hintText: 'Correo',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 7, left: 16, right: 16),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: AppTextFieldStyle.defaultInputDecoration(
              hintText: 'Contraseña',
            ),
          ),
        ),
      ],
    );
  }
}
