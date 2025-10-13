import 'package:flutter/material.dart';
import 'package:store/loading_widget.dart';

Future<T?> navigateWithLoading<T>(BuildContext context, Widget page) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const RavalLoadingIndicator();
    },
  );
  return Future.delayed(const Duration(seconds: 1), () {
    Navigator.of(context).pop(); // Close the loading dialog
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  });
}
