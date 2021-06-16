import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:file_picker/file_picker.dart';
import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/providers/user_form_provider.dart';
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:admin_dashboard/ui/cards/white_card.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_label.dart';
import 'package:email_validator/email_validator.dart';

class UserView extends StatefulWidget {
  final String uid;

  const UserView({Key? key, required this.uid}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  Usuario? user;

  @override
  void initState() {
    super.initState();
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final userFormProvider =
        Provider.of<UserFormProvider>(context, listen: false);
    usersProvider.getUserById(widget.uid).then((userDB) {
      userFormProvider.usuario = userDB;
      userFormProvider.formKey = new GlobalKey<FormState>();
      setState(() => this.user = userDB);
    }).catchError((e) {
      NotificationsService.showSnackbarError(e.toString());
      NavigationService.replaceTo(Flurorouter.dashboardUsersRoute);
    });
  }

  @override
  void dispose() {
    Provider.of<UserFormProvider>(context, listen: false).usuario = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Text('User View', style: CustomLabels.h1),
          SizedBox(height: 10),
          user == null
              ? WhiteCard(
                  child: Container(
                    alignment: Alignment.center,
                    height: 300,
                    child: CircularProgressIndicator(),
                  ),
                )
              : _UserViewBody(),
        ],
      ),
    );
  }
}

class _UserViewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        columnWidths: {
          0: FixedColumnWidth(250),
        },
        children: [
          TableRow(
            children: [
              _AvatarContainer(),
              _UserViewForm(),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserViewForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.usuario!;
    return WhiteCard(
      title: 'Información General del Usuario',
      child: Form(
        key: userFormProvider.formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              initialValue: user.nombre,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Nombre del Usuario',
                label: 'Nombre',
                icon: Icons.supervised_user_circle_outlined,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Ingrese su nombre';
                if (value.length < 6 || value.split(' ').length < 2)
                  return 'El nombre debe ser al menos nombre y apellido';
                return null;
              },
              onChanged: (value) =>
                  userFormProvider.copyUserWith(nombre: value),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: user.correo,
              decoration: CustomInputs.formInputDecoration(
                hint: 'Correo del Usuario',
                label: 'Correo',
                icon: Icons.mark_email_read_outlined,
              ),
              validator: (value) {
                if (!EmailValidator.validate(value ?? ''))
                  return 'Email no válido';
                return null;
              },
              onChanged: (value) =>
                  userFormProvider.copyUserWith(correo: value),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100),
              child: ElevatedButton(
                child: Row(
                  children: [
                    Icon(Icons.save_outlined, size: 20),
                    Text('  Guardar'),
                  ],
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () async {
                  try {
                    final response = await userFormProvider.updateUser();
                    if (response) {
                      NotificationsService.showSnackbar(
                          'Usuario ${user.nombre} Actualizado');
                      Provider.of<UsersProvider>(context, listen: false)
                          .refreshUsers(user);
                    } else {
                      NotificationsService.showSnackbarError(
                          'Usuario ${user.nombre} No Actualizado');
                    }
                  } catch (e) {
                    NotificationsService.showSnackbarError(e.toString());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _AvatarContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userFormProvider = Provider.of<UserFormProvider>(context);
    final user = userFormProvider.usuario!;
    return WhiteCard(
      width: 250,
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Profile', style: CustomLabels.h2),
            SizedBox(height: 20),
            Container(
              width: 150,
              height: 150,
              child: Stack(
                children: [
                  ClipOval(
                    child: user.img == null
                        ? Image(
                            image: AssetImage('assets/img/no-image.jpg'),
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/img/loader.gif',
                            image: user.img!,
                          ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                      ),
                      child: FloatingActionButton(
                        backgroundColor: Colors.indigo,
                        elevation: 0,
                        child: Icon(Icons.camera_alt_outlined),
                        onPressed: () async {
                          FilePickerResult? _result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                            allowMultiple: false,
                          );

                          if (_result != null) {
                            NotificationsService.showBusyIndicator(context);
                            final updateUser = await userFormProvider
                                .updateImage(_result.files.first.bytes!);
                            Provider.of<UsersProvider>(context, listen: false)
                                .refreshUsers(updateUser);
                            Navigator.of(context).pop();
                          } else {
                            NotificationsService.showSnackbarError(
                                'Imagen no Seleccionada');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              user.nombre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
