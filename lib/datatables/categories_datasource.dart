import 'package:admin_dashboard/models/category.dart';
import 'package:admin_dashboard/providers/categories_provider.dart';
import 'package:admin_dashboard/ui/modals/category_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesDataTableSource extends DataTableSource {
  final List<Category> categorias;

  final BuildContext context;

  CategoriesDataTableSource(this.context, this.categorias);

  @override
  DataRow getRow(int index) {
    final category = this.categorias[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(category.id)),
        DataCell(Text(category.nombre)),
        DataCell(Text(category.usuario.nombre)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () => showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (_) => CategoryModal(
                  categoria: category,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red.withOpacity(0.8),
              ),
              onPressed: () {
                final dialog = AlertDialog(
                  title: Text('¡Está seguro de borrarlo?'),
                  content: Text('¿Borrar definitivamente ${category.nombre}?'),
                  actions: [
                    TextButton(
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('Sí, borrar'),
                      onPressed: () async {
                        await Provider.of<CategoriesProvider>(context,
                                listen: false)
                            .borrarCategoria(category.id);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
                showDialog(context: context, builder: (_) => dialog);
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categorias.length;

  @override
  int get selectedRowCount => 0;
}
