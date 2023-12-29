import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quizzes/src/utils/utils.dart';

import '../bloc/dashboard_bloc.dart';

DashboardBloc get _bloc => findInstance<DashboardBloc>();

class WidgetDrawer extends StatefulWidget {
  const WidgetDrawer({super.key});

  @override
  State<WidgetDrawer> createState() => _WidgetDrawerState();
}

class _WidgetDrawerState extends State<WidgetDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: appContext.height,
      decoration: BoxDecoration(color: appColorBackground),
      alignment: Alignment.topCenter,
      child: BlocBuilder<DashboardBloc, DashboardState>(
          bloc: _bloc,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 32, 16, 52),
                            child: Text(
                              'SUPER ADMIN',
                              style: w500TextStyle(fontSize: 24),
                            ),
                          ),
                        ] +
                        DashboardMenu.values
                            .map<Widget>(
                              (e) => InkWell(
                                onTap: () {
                                  _bloc.add(ChangeMenuDashboardEvent(e));
                                  context.pop();
                                },
                                child: Ink(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 32),
                                  child: Row(
                                    children: [
                                      Icon(
                                        e.icon,
                                        color: state.menu == e
                                            ? appColorPrimary
                                            : appColorText.withOpacity(.7),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          e.text,
                                          style: w400TextStyle(
                                            fontSize: 16,
                                            color: state.menu == e
                                                ? appColorPrimary
                                                : appColorText.withOpacity(.7),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
