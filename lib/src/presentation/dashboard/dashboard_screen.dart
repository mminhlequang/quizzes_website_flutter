import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/base/bloc.dart';
import 'package:quizzes/src/presentation/languages/languages_screen.dart';
import 'package:quizzes/src/presentation/quizs/quizs_screen.dart';

import '../gallery/gallery_screen.dart';
import '../subjects/subjects_screen.dart';
import 'bloc/dashboard_bloc.dart';
import 'widgets/widget_drawer.dart';

DashboardBloc get _bloc => Get.find<DashboardBloc>();

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Get.find<AuthBloc>().add(const AuthLoad());
    _bloc.add(InitDashboardEvent());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Get.find<AuthBloc>().state.stateType == AuthStateType.logged) {
        _bloc.add(InitDashboardEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const WidgetDrawer(),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: Get.find<AuthBloc>(),
        listener: (_, state) {
          if (state.stateType == AuthStateType.logged) {
            _bloc.add(InitDashboardEvent());
          }
        },
        builder: (context, authState) {
          bool logged = authState.stateType == AuthStateType.logged;
          if (!logged) return const SizedBox();
          return BlocBuilder<DashboardBloc, DashboardState>(
            bloc: _bloc,
            builder: (context, state) {
              Widget child = const SizedBox();

              switch (state.menu) {
                case DashboardMenu.languages:
                  child = const LanguagesScreen();
                  break;
                case DashboardMenu.subjects:
                  child = const SubjectsScreen();
                  break;
                case DashboardMenu.quizs:
                  child = const QuizsScreen();
                  break;
                case DashboardMenu.gallery:
                  child = const GalleryScreen();
                  break;
                default:
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            isExpanded = !isExpanded;
                            scaffoldKey.currentState!.openDrawer();
                          },
                          icon: Icon(
                            Icons.menu_rounded,
                            color: appColorText,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
