import 'package:flutter/material.dart';
import 'package:store/l10n/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorPage({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/error.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 24),
              Text(
                loc.somethingWentWrong,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                loc.noInternetConnection,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(loc.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
