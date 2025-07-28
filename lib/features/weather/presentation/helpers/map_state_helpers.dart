import 'package:flutter/material.dart';

class MapStateHelpers {
  static void showError(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: onRetry != null
            ? SnackBarAction(label: 'Reintentar', onPressed: onRetry)
            : null,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showWarning(BuildContext context, String message,
      {VoidCallback? onRetry}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        action: onRetry != null
            ? SnackBarAction(label: 'Reintentar', onPressed: onRetry)
            : null,
      ),
    );
  }
}
