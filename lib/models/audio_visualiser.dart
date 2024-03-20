import 'dart:math' as math;

import 'package:flutter/material.dart';

class AudioVisualizer extends StatelessWidget {
  final AnimationController controller;
  final Color songColor;

  const AudioVisualizer({
    Key? key,
    required this.controller,
    required this.songColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth / 50;
        return AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                20,
                (index) {
                  final barHeight =
                      (controller.value * (math.Random().nextDouble() * 100)) +
                          10.0;
                  return Container(
                    width: barWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: songColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
