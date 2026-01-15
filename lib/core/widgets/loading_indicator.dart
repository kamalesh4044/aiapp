import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double? size;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.message,
    this.size = 50,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? ThemeConstants.primaryColor,
              ),
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: ThemeConstants.spacing16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
