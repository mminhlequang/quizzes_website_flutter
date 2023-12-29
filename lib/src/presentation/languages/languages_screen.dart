import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/firestore_resources/constants.dart';
import 'package:quizzes/src/firestore_resources/instances.dart';
import 'package:quizzes/src/presentation/widgets/widget_fab_ani.dart';

import '../widgets/widget_popup_container.dart';
import '../widgets/widget_row_value.dart';
import 'bloc/languages_bloc.dart';
import 'widgets/widget_form_create.dart';

LanguagesBloc get _bloc => Get.find<LanguagesBloc>();

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({super.key});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bloc.add(const FetchLanguagesEvent(page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WidgetFABAni(
        shouldShow: true,
        animationDuration: const Duration(milliseconds: 250),
        fab: FloatingActionButton(
          heroTag: 'WidgetFormCreateLangs',
          backgroundColor: appColorPrimary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return const WidgetFormCreateLangs();
                }));
          },
        ),
      ),
      body: BlocBuilder<LanguagesBloc, LanguagesState>(
          bloc: _bloc,
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Languages",
                          style: w600TextStyle(fontSize: 28),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "${state.count} rows",
                          style: w400TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                Gap(32),
                Row(
                  children: [
                    SizedBox(
                      width: 280.0,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Type some thing...",
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appColorPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Page:',
                      style: w400TextStyle(),
                    ),
                    Gap(4),
                    IconButton(
                      onPressed: state.page == 1
                          ? null
                          : () {
                              _bloc.add(
                                  FetchLanguagesEvent(page: state.page - 1));
                            },
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: state.page == 1 ? appColorElement : appColorText,
                      ),
                    ),
                    Text(
                      ' ${state.page} ',
                      style: w500TextStyle(),
                    ),
                    IconButton(
                      onPressed: state.page * state.limit >= state.count
                          ? null
                          : () {
                              _bloc.add(
                                  FetchLanguagesEvent(page: state.page + 1));
                            },
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: state.page * state.limit >= state.count
                            ? appColorElement
                            : appColorText,
                      ),
                    ),
                    Gap(12),
                    WidgetOverlayActions(
                      builder: (Widget child,
                          Size size,
                          Offset childPosition,
                          Offset? pointerPosition,
                          double animationValue,
                          Function hide) {
                        return Positioned(
                          right: MediaQuery.of(context).size.width -
                              childPosition.dx -
                              size.width,
                          top: childPosition.dy + size.height + 8,
                          child: WidgetPopupContainer(
                            alignmentTail: Alignment.topRight,
                            child: Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Material(
                                color: Colors.transparent,
                                child: Column(
                                  children: List.generate(
                                    5,
                                    (index) => InkWell(
                                      onTap: () {
                                        hide();
                                        _bloc.add(FetchLanguagesEvent(
                                            page: 1, limit: (index + 1) * 10));
                                      },
                                      child: Ink(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${(index + 1) * 10} items',
                                              style: w400TextStyle(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            'Limit:',
                            style: w400TextStyle(),
                          ),
                          Gap(4),
                          Text(
                            '${state.limit} items',
                            style: w500TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(32),
                Expanded(
                  child: Column(
                    children: [
                      WidgetRowHeader(
                        child: Row(
                          children: const [
                            WidgetRowValue.label(
                                flex: 4, value: kdb_languageName),
                            WidgetRowValue.label(
                                flex: 4, value: kdb_languageCode),
                            WidgetRowValue.label(flex: 8, value: kdb_isPublic),
                          ],
                        ),
                      ),
                      Gap(20),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: searchController,
                            builder: (context, value, child) {
                              String keyword = value.text;
                              List<QueryDocumentSnapshot<Map>> items =
                                  List.from((state.items ?? []).where((e) =>
                                      e
                                          .data()[kdb_languageName]
                                          .toString()
                                          .isContainsASCII(keyword) ||
                                      e
                                          .data()[kdb_languageCode]
                                          .toString()
                                          .isContainsASCII(keyword)));
                              return ListView.separated(
                                itemCount: items.length,
                                separatorBuilder: (context, index) => Container(
                                  height: .6,
                                  color: Colors.grey.shade200,
                                ),
                                itemBuilder: (_, index) {
                                  var e = items[index];

                                  return WidgetRowItem(
                                    key: ValueKey(e),
                                    child: Row(
                                      children: [
                                        WidgetRowValue(
                                          flex: 4,
                                          value: e.data()[kdb_languageName],
                                          callback: (value) async {
                                            await colLangs
                                                .doc(
                                                    '${e.data()[kdb_languageCode]}')
                                                .update(
                                                    {kdb_languageName: value});
                                            _bloc.add(
                                                const FetchLanguagesEvent());
                                          },
                                        ),
                                        WidgetRowValue(
                                          flex: 4,
                                          value: e.data()[kdb_languageCode],
                                        ),
                                        WidgetRowValue(
                                          flex: 8,
                                          cellDataType: CellDataType.bol,
                                          value: e.data()[kdb_isPublic],
                                          label: 'Set to public',
                                          callback: (value) async {
                                            await colLangs
                                                .doc(
                                                    '${e.data()[kdb_languageCode]}')
                                                .update({kdb_isPublic: value});
                                            _bloc.add(
                                                const FetchLanguagesEvent());
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
