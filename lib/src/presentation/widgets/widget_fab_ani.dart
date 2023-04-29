import 'package:flutter/material.dart';

class WidgetFABAni extends StatelessWidget {
  /// The duration for the animation
  /// Defaults to the app's theme duration.
  final Duration animationDuration;

  /// The floating action button widget to show/hide.
  final FloatingActionButton fab;

  /// Curve to apply when [fab] is coming into view.
  final Curve showCurve;

  /// Curve to apply when [fab] is disappearing from view.
  final Curve hideCurve;

  /// boolean to toggle show/hide [fab]
  final bool shouldShow;

  /// Creates a [WidgetFABAni] widget.
  ///
  /// [fab] parameter must not be null.
  /// [shouldShow] parameter toggles the [fab] (true/false => show/hide).
  const WidgetFABAni({
    Key? key,
    required this.fab,
    this.animationDuration = kThemeAnimationDuration,
    this.showCurve = Curves.linear,
    this.hideCurve = Curves.linear,
    this.shouldShow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: showCurve,
      switchOutCurve: hideCurve,
      child: shouldShow ? fab : const Offstage(),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
    );
  }
}
