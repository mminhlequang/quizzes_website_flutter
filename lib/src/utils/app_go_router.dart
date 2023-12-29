import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzes/src/presentation/coming_soon/coming_soon_screen.dart';
import 'package:quizzes/src/presentation/dashboard/dashboard_screen.dart';

import 'utils.dart';

GlobalKey<NavigatorState> get appNavigatorKey =>
    findInstance<GlobalKey<NavigatorState>>();
bool get isAppContextReady => appNavigatorKey.currentContext != null;
BuildContext get appContext => appNavigatorKey.currentContext!;

clearAllRouters([String? router]) {
  try {
    while (appContext.canPop() == true) {
      appContext.pop();
    }
  } catch (_) {}
  if (router != null) {
    appContext.pushReplacement(router);
  }
}

pushWidget(
    {required child,
    String? routeName,
    bool opaque = true,
    bool replacement = false}) {
  if (replacement) {
    return Navigator.of(appContext).pushReplacement(PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      settings: RouteSettings(name: routeName),
    ));
  } else {
    return Navigator.of(appContext).push(PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      settings: RouteSettings(name: routeName),
    ));
  }
}

abstract class AppRoutes {
  static const comingSoon = '/coming_soon';
  static const dashboard = '/dashboard';
}

// GoRouter configuration
final goRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  initialLocation: kDebugMode ? AppRoutes.dashboard : AppRoutes.comingSoon,
  routes: [
    GoRoute(
      name: AppRoutes.comingSoon,
      path: AppRoutes.comingSoon,
      pageBuilder: _defaultPageBuilder((state) => const ComingSoonScreen()),
    ),
    GoRoute(
      name: AppRoutes.dashboard,
      path: AppRoutes.dashboard,
      pageBuilder: _defaultPageBuilder((state) => const DashboardScreen()),
    ),
  ],
);

Page<dynamic> Function(BuildContext, GoRouterState) _defaultPageBuilder<T>(
        Widget Function(GoRouterState) builder) =>
    (BuildContext context, GoRouterState state) {
      return _buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        name: state.name,
        child: builder(state),
      );
    };

CustomTransitionPage _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  required String? name,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    name: name,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
