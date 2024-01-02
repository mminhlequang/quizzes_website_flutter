import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzes/src/utils/utils.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:simple_animations/simple_animations.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({super.key});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AnimatedBackground(),
        AnimatedColorBuilder(
          builder: (color) {
            return CircularParticle(
              awayRadius: 80,
              numberOfParticles: 380,
              speedOfParticles: .25,
              height: appContext.height,
              width: appContext.width,
              onTapAnimation: true,
              awayAnimationDuration: const Duration(milliseconds: 600),
              maxParticleSize: 6,
              isRandSize: true,
              isRandomColor: true,
              randColorList: [color],
              awayAnimationCurve: Curves.easeInOutBack,
              enableHover: true,
              hoverColor: Colors.white,
              particleColor: color,
              hoverRadius: 90,
              connectDots: true, //not recommended
            );
          },
        ),
        GestureDetector(
          onLongPress: () {
            appContext.pushReplacement(AppRoutes.dashboard);
          },
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: SizedBox(
                width: 1280,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController colorController;
  late Animation<Color?> color1;
  late Animation<Color?> color2;

  @override
  void initState() {
    colorController = AnimationController(vsync: this)
      ..mirror(duration: const Duration(milliseconds: 6000))
      ..repeat(reverse: true);

    color1 = ColorTween(
            begin: const Color(0xff8a113a), end: Colors.lightBlue.shade900)
        .animate(colorController);
    color2 =
        ColorTween(begin: const Color(0xff440216), end: Colors.blue.shade600)
            .animate(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorController,
      builder: (_, child) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1.value!, color2.value!])),
        );
      },
    );
  }
}

class AnimatedColorBuilder extends StatefulWidget {
  final Widget Function(Color color) builder;
  const AnimatedColorBuilder({super.key, required this.builder});

  @override
  State<AnimatedColorBuilder> createState() => _AnimatedColorBuilderState();
}

class _AnimatedColorBuilderState extends State<AnimatedColorBuilder>
    with TickerProviderStateMixin {
  late AnimationController colorController;
  late Animation<Color?> color1;

  @override
  void initState() {
    colorController = AnimationController(vsync: this)
      ..mirror(duration: const Duration(milliseconds: 6000))
      ..repeat(reverse: true);

    color1 = ColorTween(
            begin: const Color(0xff8a113a), end: Colors.lightBlue.shade900)
        .animate(colorController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorController,
      builder: (_, child) {
        return widget.builder(color1.value!);
      },
    );
  }
}
