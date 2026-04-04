import 'package:flutter/material.dart';

class AconsiaBrandLogo extends StatelessWidget {
  const AconsiaBrandLogo({
    super.key,
    this.size = 96,
    this.imageSize = 60,
    this.shadow = true,
  });

  final double size;
  final double imageSize;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Image.asset(
          'assets/logo/aconsia_logo.png',
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
