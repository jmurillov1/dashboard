import 'package:admin_dashboard/models/category.dart';
import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/services/notifications_service.dart';
import 'package:admin_dashboard/ui/buttons/custom_outlined_button.dart';
import 'package:admin_dashboard/ui/inputs/custom_inputs.dart';
import 'package:admin_dashboard/ui/labels/custom_label.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryModal extends StatefulWidget {
  final Category? categoria;

  const CategoryModal({Key? key, this.categoria}) : super(key: key);
  @override
  _CategoryModalState createState() => _CategoryModalState();
}

class _CategoryModalState extends State<CategoryModal> {
  String nombre = '';
  String? id;

  @override
  void initState() {
    super.initState();
    id = widget.categoria?.id;
    nombre = widget.categoria?.nombre ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider =
        Provider.of<CategoriesProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      width: 300,
      decoration: buildBoxDecoration(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.categoria?.nombre ?? 'Nueva Categoría',
                style: CustomLabels.h1.copyWith(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.close_outlined),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 20),
          TextFormField(
            initialValue: widget.categoria?.nombre ?? '',
            onChanged: (value) => nombre = value,
            decoration: CustomInputs.authInputDecoration(
              hint: 'Nombre de la Categoría',
              label: 'Categoría',
              icon: Icons.new_releases_outlined,
            ),
            style: TextStyle(color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.center,
            child: CustomOutlinedButton(
              text: 'Guardar',
              color: Colors.white,
              onPressed: () async {
                try {
                  if (id == null) {
                    await categoriesProvider.crearCategoria(nombre);
                    NotificationsService.showSnackbar(
                        'Categoría $nombre Registrada');
                  } else {
                    await categoriesProvider.actualizarCategoria(id!, nombre);
                    NotificationsService.showSnackbar(
                        'Categoría $nombre Actualizada');
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  NotificationsService.showSnackbarError(e.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() => BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Color(0xff0F2041),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
            )
          ]);
}
