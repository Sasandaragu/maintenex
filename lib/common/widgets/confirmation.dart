import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onYesPressed;

  const ConfirmationDialog({
    required this.message,
    required this.onYesPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation'),
      content: Text(message),
      actions: <Widget>[
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          icon: const Icon(Icons.cancel),
          label: const Text('No'),
        ),
        TextButton.icon(
          onPressed: () {
            onYesPressed();
            Navigator.of(context).pop(); // Close the dialog
          },
          icon: const Icon(Icons.check_circle),
          label: const Text('Yes'),
        ),
      ],
    );
  }
}