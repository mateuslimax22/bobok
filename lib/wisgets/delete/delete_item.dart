import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final String item;
  final VoidCallback onDelete;
  final bool isVisible;

  const DeleteConfirmationModal({
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
              content: Text(
                '${AppLocalizations.of(context)!.deleteItem}$item?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 15,
                  letterSpacing: 1.5,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancel,
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
                    AppLocalizations.of(context)!.confirm,
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
