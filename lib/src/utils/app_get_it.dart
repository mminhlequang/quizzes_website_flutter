import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../presentation/auth/bloc/sign_in_bloc.dart';
import '../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../presentation/gallery/bloc/gallery_bloc.dart';
import '../presentation/languages/bloc/languages_bloc.dart';
import '../presentation/quiz_form/bloc/quiz_form_bloc.dart';
import '../presentation/quizs/bloc/quizs_bloc.dart';
import '../presentation/subjects/bloc/subjects_bloc.dart';

import '../base/bloc.dart';

final getIt = GetIt.instance;

T findInstance<T extends Object>() {
  return getIt<T>();
}

void getItSetup() {
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
      GlobalKey<NavigatorState>());
  getIt.registerSingleton<AuthBloc>(AuthBloc());
  getIt.registerLazySingleton<SignInBloc>(() => SignInBloc());
  getIt.registerLazySingleton<DashboardBloc>(() => DashboardBloc());
  getIt.registerLazySingleton<LanguagesBloc>(() => LanguagesBloc());
  getIt.registerLazySingleton<GalleryBloc>(() => GalleryBloc());
  getIt.registerLazySingleton<SubjectsBloc>(() => SubjectsBloc());
  getIt.registerLazySingleton<QuizsBloc>(() => QuizsBloc());
  getIt.registerLazySingleton<QuizFormBloc>(() => QuizFormBloc());
}
