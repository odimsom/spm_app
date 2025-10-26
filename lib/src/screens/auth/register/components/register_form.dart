import 'package:flutter/material.dart';
import 'package:spm/src/core/theme/styles/text_field_styles.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const RegisterForm({
    super.key,
    this.nameController,
    this.emailController,
    this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField para Nombre
        Padding(
          padding: const EdgeInsets.only(bottom: 7, left: 16, right: 16),
          child: TextField(
            controller: nameController,
            decoration: AppTextFieldStyle.defaultInputDecoration(
              hintText: 'Nombre',
            ),
          ),
        ),
        // TextField para Correo
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
          child: TextField(
            controller: emailController,
            decoration: AppTextFieldStyle.defaultInputDecoration(
              hintText: 'Correo',
            ),
          ),
        ),
        // TextField para Contraseña
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
