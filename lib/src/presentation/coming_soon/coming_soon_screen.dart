import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quizzes/src/utils/utils.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:get/get.dart';

class ComingSoonScreen extends StatefulWidget {
  const ComingSoonScreen({super.key});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setFriendlyRouteName(
          title: 'imagineeringwithus - Engineering Your Ideas to Life',
          url: '/coming_soon');
    });
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
              height: Get.height,
              width: Get.width,
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
        Material(
          color: Colors.transparent,
          child: Center(
            child: SizedBox(
              width: 1280,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          WidgetGlassBackground(
                            blur: 2,
                            backgroundColor: Colors.white10,
                            borderRadius: BorderRadius.circular(999),
                            padding: EdgeInsets.zero,
                            child: SizedBox(
                              width: 48,
                              height: 48,
                              child: Center(
                                child: Image.asset(assetpng('logo_512')),
                              ),
                            ),
                          ),
                          const Gap(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'imagineeringwithus',
                                style: w700TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              const Gap(4),
                              Text(
                                'Engineering Your Ideas to Life ',
                                style: w400TextStyle(
                                    color: Colors.white.withOpacity(.6)),
                              ),
                            ],
                          ),
                          const Spacer(),
                          WidgetRippleButton(
                            onTap: () {},
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              child: AnimatedColorBuilder(builder: (color) {
                                return Text(
                                  'Contact us',
                                  style:
                                      w500TextStyle(fontSize: 16, color: color),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
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
