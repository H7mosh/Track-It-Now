import 'package:flutter/material.dart';

import '../config/theme.dart';


class LoadingIndicator extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.fullScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: AppTheme.primaryColor,
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ],
    );

    if (fullScreen) {
      return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        body: Center(
          child: loadingContent,
        ),
      );
    }

    return Center(
      child: loadingContent,
    );
  }
}