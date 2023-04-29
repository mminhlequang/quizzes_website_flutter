import 'package:get/get.dart';
import '../presentation/auth/bloc/sign_in_bloc.dart';
import '../presentation/coming_soon/coming_soon_screen.dart';
import '../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../presentation/dashboard/dashboard_screen.dart';
import '../presentation/gallery/bloc/gallery_bloc.dart';
import '../presentation/languages/bloc/languages_bloc.dart';
import '../presentation/quiz_form/bloc/quiz_form_bloc.dart';
import '../presentation/quizs/bloc/quizs_bloc.dart';
import '../presentation/subjects/bloc/subjects_bloc.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: Routes.coming_soon,
      page: () => const ComingSoonScreen(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
      bindings: [
        BindingsBuilder.put(() => SignInBloc()),
        BindingsBuilder.put(() => DashboardBloc()),
        BindingsBuilder.put(() => LanguagesBloc()),
        BindingsBuilder.put(() => GalleryBloc()),
        BindingsBuilder.put(() => SubjectsBloc()),
        BindingsBuilder.put(() => QuizsBloc()),
        BindingsBuilder.put(() => QuizFormBloc()),
      ],
    ),
  ];
}

abstract class Routes {
  static const coming_soon = '/coming_soon';
  static const dashboard = '/dashboard';
}
