import 'package:admin_dashboard/providers/auth_provider.dart';
import 'package:admin_dashboard/providers/register_form_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/buttons/link_text.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => RegisterFormProvider(),
      child: Builder(
        builder: (context) {
          final registerFormProvider =
              Provider.of<RegisterFormProvider>(context, listen: false);
          return Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 370),
                child: Form(
                  key: registerFormProvider.formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: CustomInputs.authInputDecoration(
                          hint: 'Ingrese su nombre',
                          label: 'Nombre',
                          icon: Icons.supervised_user_circle_sharp,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Ingrese su nombre';
                          if (value.length < 6 && value.split(' ').length < 2)
                            return 'El nombre debe ser al menos nombre y apellido';
                          return null;
                        },
                        onChanged: (value) => registerFormProvider.name = value,
                      ),
                      SizedBox(height: 20),
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
                        onChanged: (value) =>
                            registerFormProvider.email = value,
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
                        onChanged: (value) =>
                            registerFormProvider.password = value,
                      ),
                      SizedBox(height: 20),
                      CustomOutlinedButton(
                        text: 'Crear Cuenta',
                        onPressed: () {
                          final validForm = registerFormProvider.validateForm();
                          if (!validForm) return;
                          final authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          authProvider.register(
                            registerFormProvider.name,
                            registerFormProvider.email,
                            registerFormProvider.password,
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      LinkText(
                        text: 'Ir al Login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Flurorouter.loginRoute);
                        },
                      )
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
