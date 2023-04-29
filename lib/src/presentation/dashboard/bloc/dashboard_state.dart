part of 'dashboard_bloc.dart';

class DashboardState {
  DashboardMenu menu;

  DashboardState({
    this.menu = DashboardMenu.languages,
  });

  DashboardState update({
    DashboardMenu? menu,
  }) {
    return DashboardState(
      menu: menu ?? this.menu,
    );
  }
}

enum DashboardMenu { languages, subjects, quizs, gallery, reports }

extension DashboardMenuExt on DashboardMenu {
  String get text {
    switch (this) {
      case DashboardMenu.languages:
        return 'Languages';
      case DashboardMenu.subjects:
        return 'Subjects';
      case DashboardMenu.quizs:
        return 'Quizs';
      case DashboardMenu.gallery:
        return 'Gallery';
      case DashboardMenu.reports:
        return 'Reports';
    }
  }

  IconData get icon {
    switch (this) {
      case DashboardMenu.languages:
        return Icons.language;
      case DashboardMenu.subjects:
        return Icons.abc_outlined;
      case DashboardMenu.quizs:
        return Icons.quiz_outlined;
      case DashboardMenu.gallery:
        return Icons.image_search_rounded;
      case DashboardMenu.reports:
        return Icons.report_gmailerrorred;
    }
  }
}
