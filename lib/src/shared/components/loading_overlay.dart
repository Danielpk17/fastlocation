import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: AppColors.overlay,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(AppMetrics.spacingLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppMetrics.spacingMd),
                  Text(message),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
