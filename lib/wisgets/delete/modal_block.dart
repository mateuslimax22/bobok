import 'package:flutter/material.dart';

class BlockConfirmationModal extends StatelessWidget {
  final String item;
  final VoidCallback onDelete;
  final bool isVisible;

  const BlockConfirmationModal({
    super.key,
    required this.item,
    required this.onDelete,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Text(
                      'Deseja bloquear o usuário "$item"?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        'Ao fazer isso vocês não teram acesso a nada um do outro.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 15,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 15,
                          letterSpacing: 1.5)),
                ),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 15,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      });
    }

    return Container(); // Return an empty container, as we don't want to render anything here.
  }
}
