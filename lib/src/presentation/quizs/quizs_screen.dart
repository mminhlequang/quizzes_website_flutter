import 'dart:math';

import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';
import 'package:quizzes/src/presentation/widgets/widget_fab_ani.dart';

import '../widgets/widget_delete_button.dart';
import '../widgets/widget_popup_container.dart';
import '../widgets/widget_row_value.dart';
import 'bloc/quizs_bloc.dart';
import '../quiz_form/quiz_form_screen.dart';

QuizsBloc get _bloc => Get.find<QuizsBloc>();

class QuizsScreen extends StatefulWidget {
  const QuizsScreen({super.key});

  @override
  State<QuizsScreen> createState() => _QuizsScreenState();
}

class _QuizsScreenState extends State<QuizsScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bloc.add(InitQuizsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WidgetFABAni(
        shouldShow: true,
        animationDuration: const Duration(milliseconds: 250),
        fab: FloatingActionButton(
          heroTag: 'WidgetFormCreateQuizs',
          backgroundColor: appColorPrimary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return const QuizFormScreen();
                }));
          },
        ),
      ),
      body: BlocBuilder<QuizsBloc, QuizsState>(
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
                          "Quizs",
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
                const Gap(32),
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
                    Row(
                      children: [
                        WidgetOverlayActions(
                          gestureType: state.itemsLangs != null
                              ? GestureType.onTap
                              : GestureType.none,
                          builder: (Widget child,
                              Size size,
                              Offset childPosition,
                              Offset? pointerPosition,
                              double animationValue,
                              Function hide) {
                            return Positioned(
                              left: childPosition.dx,
                              top: childPosition.dy + size.height + 8,
                              child: WidgetPopupContainer(
                                alignmentTail: Alignment.topLeft,
                                paddingTail: const EdgeInsets.only(left: 16),
                                child: Container(
                                  width: 120,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      children: state.itemsLangs!
                                          .map(
                                            (e) => InkWell(
                                              onTap: () {
                                                hide();
                                                _bloc.add(ChangeLangQuizsEvent(
                                                    e.data()));
                                              },
                                              child: Ink(
                                                color: e.data()[
                                                            kdb_languageCode] ==
                                                        state.language![
                                                            kdb_languageCode]
                                                    ? Colors.grey[100]
                                                    : Colors.transparent,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 16),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    '${e.data()[kdb_languageName]}',
                                                    style: w400TextStyle(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              if (state.language != null) ...[
                                Text('Language: ',
                                    style: w300TextStyle(
                                        fontSize: 14,
                                        color: hexColor('#68686A'))),
                                const Gap(4),
                                Text(
                                  '${state.language![kdb_languageName]}',
                                  style: w500TextStyle(),
                                )
                              ],
                            ],
                          ),
                        ),
                        const Gap(24),
                        InkWell(
                          onTap: () {
                            _bloc.add(ChangeFilterQuizsEvent(
                                isForKid: !state.isForKid));
                          },
                          child: Row(
                            children: [
                              Text('is subject ForKid:',
                                  style: w300TextStyle(
                                      fontSize: 14,
                                      color: hexColor('#68686A'))),
                              const Gap(4),
                              CircleAvatar(
                                backgroundColor: state.isForKid
                                    ? appColorPrimary
                                    : appColorElement,
                                radius: 6,
                                child: !state.isForKid
                                    ? const SizedBox()
                                    : const Center(
                                        child: Icon(
                                          CupertinoIcons.check_mark,
                                          size: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(24),
                        WidgetOverlayActions(
                          gestureType: state.itemsSubjects != null
                              ? GestureType.onTap
                              : GestureType.none,
                          builder: (Widget child,
                              Size size,
                              Offset childPosition,
                              Offset? pointerPosition,
                              double animationValue,
                              Function hide) {
                            return Positioned(
                              left: childPosition.dx,
                              top: childPosition.dy + size.height + 8,
                              child: WidgetPopupContainer(
                                alignmentTail: Alignment.topLeft,
                                paddingTail: const EdgeInsets.only(left: 16),
                                child: Container(
                                  width: 120,
                                  height: min(
                                      260,
                                      state.itemsSubjects!.length * 24 +
                                          12 * 2),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: state.itemsSubjects!
                                            .map(
                                              (e) => InkWell(
                                                onTap: () {
                                                  hide();
                                                  _bloc.add(
                                                      ChangeSubjectQuizsEvent(
                                                          e.data()));
                                                },
                                                child: Ink(
                                                  color: e.data()[kdb_id] ==
                                                          state.subject![kdb_id]
                                                      ? Colors.grey[100]
                                                      : Colors.transparent,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${e.data()[kdb_label]}',
                                                      style: w400TextStyle(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              if (state.subject != null) ...[
                                Text('Subject:',
                                    style: w300TextStyle(
                                        fontSize: 14,
                                        color: hexColor('#68686A'))),
                                const Gap(4),
                                Text(
                                  '${state.subject![kdb_label]} '
                                  "(${state.countWithFilter})",
                                  style: w500TextStyle(),
                                ),
                              ]
                            ],
                          ),
                        ),
                        const Gap(24),
                        InkWell(
                          onTap: () {
                            _bloc.add(ChangeFilterQuizsEvent(
                                isPublic: !state.isPublic));
                          },
                          child: Row(
                            children: [
                              Text('isPublic:',
                                  style: w300TextStyle(
                                      fontSize: 14,
                                      color: hexColor('#68686A'))),
                              const Gap(4),
                              CircleAvatar(
                                backgroundColor: state.isPublic
                                    ? appColorPrimary
                                    : appColorElement,
                                radius: 6,
                                child: !state.isPublic
                                    ? const SizedBox()
                                    : const Center(
                                        child: Icon(
                                          CupertinoIcons.check_mark,
                                          size: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(32),
                    Text(
                      'Page:',
                      style: w400TextStyle(),
                    ),
                    const Gap(4),
                    IconButton(
                      onPressed: state.page == 1
                          ? null
                          : () {
                              _bloc.add(FetchQuizsEvent(page: state.page - 1));
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
                              _bloc.add(FetchQuizsEvent(page: state.page + 1));
                            },
                      icon: Icon(
                        Icons.chevron_right_rounded,
                        color: state.page * state.limit >= state.count
                            ? appColorElement
                            : appColorText,
                      ),
                    ),
                    const Gap(12),
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
                                        _bloc.add(FetchQuizsEvent(
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
                          const Gap(4),
                          Text(
                            '${state.limit} items',
                            style: w500TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(32),
                Expanded(
                  child: Column(
                    children: [
                      const WidgetRowHeader(
                        child: Row(
                          children: [
                            WidgetRowValue.label(flex: 4, value: kdb_question),
                            WidgetRowValue.label(flex: 4, value: kdb_hint),
                            WidgetRowValue.label(flex: 2, value: kdb_answers),
                            WidgetRowValue.label(flex: 8, value: kdb_explain),
                            WidgetRowValue.label(value: kdb_isPublic),
                            WidgetRowValue.label(flex: 1, value: ''),
                          ],
                        ),
                      ),
                      const Gap(20),
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
                                          value: e.data()[kdb_question],
                                          maxLines: 99,
                                          callback: (value) async {
                                            await colQuizs
                                                .doc('${e.data()[kdb_id]}')
                                                .update({kdb_question: value});
                                            _bloc.add(const FetchQuizsEvent());
                                          },
                                        ),
                                        WidgetRowValue(
                                          flex: 4,
                                          value: e.data()[kdb_hint],
                                          maxLines: 99,
                                          callback: (value) async {
                                            await colQuizs
                                                .doc('${e.data()[kdb_id]}')
                                                .update({kdb_hint: value});
                                            _bloc.add(const FetchQuizsEvent());
                                          },
                                        ),
                                        WidgetRowValue(
                                          flex: 2,
                                          valueHover: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: e
                                                  .data()[kdb_answers]
                                                  .map<Widget>((e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 2),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              '${e[kdb_value]}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  w300TextStyle(),
                                                            ),
                                                            const Gap(4),
                                                            if (e[kdb_isCorrect] ==
                                                                    true ||
                                                                e[kdb_isCorrect] ==
                                                                    1)
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    appColorPrimary,
                                                                radius: 6,
                                                                child:
                                                                    const Center(
                                                                  child: Icon(
                                                                    CupertinoIcons
                                                                        .check_mark,
                                                                    size: 8,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                          value: e
                                              .data()[kdb_answers]
                                              .firstWhere((e) {
                                            return e[kdb_isCorrect] == true ||
                                                e[kdb_isCorrect] == 1;
                                          })[kdb_value],
                                          maxLines: 99,
                                        ),
                                        WidgetRowValue(
                                          flex: 8,
                                          value: e.data()[kdb_explain],
                                          maxLines: 99,
                                        ),
                                        WidgetRowValue(
                                          flex: 1,
                                          maxLines: 99,
                                          cellDataType: CellDataType.bol,
                                          value: e.data()[kdb_isPublic],
                                          label: 'Set to isPublic',
                                          callback: (value) async {
                                            await colQuizs
                                                .doc('${e.data()[kdb_id]}')
                                                .update({kdb_isPublic: value});
                                            _bloc.add(const FetchQuizsEvent());
                                          },
                                        ),
                                        WidgetRowValue(
                                          flex: 1,
                                          value: WidgetDeleteButton(
                                            callback: () async {
                                              await colQuizs
                                                  .doc('${e.data()[kdb_id]}')
                                                  .delete();
                                              _bloc
                                                  .add(const FetchQuizsEvent());
                                            },
                                          ),
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
