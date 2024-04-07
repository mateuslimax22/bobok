import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BlockConfirmationModal extends StatefulWidget {
  final String item;
  final Function()? onDelete;
  final bool isVisible;

  const BlockConfirmationModal({
    super.key,
    required this.item,
    required this.onDelete,
    required this.isVisible,
  });

  @override
  State<BlockConfirmationModal> createState() => _BlockConfirmationModalState();
}

class _BlockConfirmationModalState extends State<BlockConfirmationModal> {
  @override
  Widget build(BuildContext context) {
    if (widget.isVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Text(
                      '${AppLocalizations.of(context)!.blockUser}${widget.item}?',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        AppLocalizations.of(context)!.blockMsg,
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
                  child: Text(AppLocalizations.of(context)!.cancel,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 15,
                          letterSpacing: 1.5)),
                ),
                TextButton(
                  onPressed: () async {
                    await widget.onDelete!();
                    // ignore: use_build_context_synchronously
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
