import 'package:flutter/material.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final String item;
  final VoidCallback onDelete;

  const DeleteConfirmationModal(
      {Key? key, required this.item, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Modal de confirmação
        AlertDialog(
          content: Text('Deseja excluir o item "$item"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ],
    );
  }
}
