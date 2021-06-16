import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/providers/login_form_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => LoginFormProvider(),
      child: Builder(builder: (BuildContext context) {
        final loginFormProvider =
            Provider.of<LoginFormProvider>(context, listen: false);
        return Container(
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 370),
              child: Form(
                key: loginFormProvider.formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: CustomInputs.authInputDecoration(
                        hint: 'Ingrese su correo',
                        label: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      validator: (value) {
                        if (!EmailValidator.validate(value ?? ''))
                          return 'Email no válido';
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          onFormSubmit(loginFormProvider, authProvider),
                      onChanged: (value) => loginFormProvider.email = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      obscuringCharacter: '*',
                      style: TextStyle(color: Colors.white),
                      decoration: CustomInputs.authInputDecoration(
                        hint: '**********',
                        label: 'Contraseña',
                        icon: Icons.lock_outline_rounded,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Ingrese su contraseña';
                        if (value.length < 6)
                          return 'La contraseña debe de ser mayor o igual a seis caracteres';
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          onFormSubmit(loginFormProvider, authProvider),
                      onChanged: (value) => loginFormProvider.password = value,
                    ),
                    SizedBox(height: 20),
                    CustomOutlinedButton(
                      text: 'Ingresar',
                      onPressed: () =>
                          onFormSubmit(loginFormProvider, authProvider),
                    ),
                    SizedBox(height: 20),
                    LinkText(
                      text: 'Nueva Cuenta',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, Flurorouter.registerRoute);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void onFormSubmit(
      LoginFormProvider loginFormProvider, AuthProvider authProvider) {
    final isValid = loginFormProvider.validateForm();
    if (isValid)
      authProvider.login(loginFormProvider.email, loginFormProvider.password);
  }
}
