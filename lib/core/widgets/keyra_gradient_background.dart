import 'package:flutter/material.dart';

class KeyraGradientBackground extends StatelessWidget {
  final Widget child;
  final Color? gradientColor;

  const KeyraGradientBackground({
    super.key,
    required this.child,
    this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = gradientColor ?? Theme.of(context).colorScheme.primary;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: child,
    );
  }
}
