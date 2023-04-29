import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quizzes/src/utils/utils.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState()) {
    on<InitDashboardEvent>(_init);
    on<ChangeMenuDashboardEvent>(_changeMenu);
  }

  _init(InitDashboardEvent event, emit) {
    add(const ChangeMenuDashboardEvent(DashboardMenu.subjects));
  }

  _changeMenu(ChangeMenuDashboardEvent event, emit) {
    emit(state.update(menu: event.menu));
    setFriendlyRouteName(
        title: event.menu.text, url: 'dashboard/${event.menu.name}');
  }
}
