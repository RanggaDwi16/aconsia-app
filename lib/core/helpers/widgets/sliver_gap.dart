// A widget that provides a vertical gap in a sliver list.
import 'package:flutter/material.dart';

class SliverGap extends StatelessWidget {
  final double gapHeight;
  const SliverGap(this.gapHeight, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(height: gapHeight),
    );
  }
}
