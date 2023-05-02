import 'dart:math';

import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/firestore_resources/constants.dart';
import 'package:quizzes/src/firestore_resources/instances.dart';
import 'package:quizzes/src/presentation/widgets/widget_fab_ani.dart';

import '../quizs/bloc/quizs_bloc.dart';
import '../widgets/widget_delete_button.dart';
import '../widgets/widget_popup_container.dart';
import '../widgets/widget_row_value.dart';
import 'bloc/subjects_bloc.dart';
import 'widgets/widget_form_create.dart';

SubjectsBloc get _bloc => Get.find<SubjectsBloc>();

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _bloc.add(InitSubjectsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: WidgetFABAni(
        shouldShow: true,
        animationDuration: const Duration(milliseconds: 250),
        fab: FloatingActionButton(
          heroTag: 'WidgetFormCreateSubjects',
          backgroundColor: appColorPrimary,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  return const WidgetFormCreateSubjects();
                }));
          },
        ),
      ),
      body: BlocBuilder<SubjectsBloc, SubjectsState>(
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
                        "Subjects",
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
              kSpacingHeight32,
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
                                              _bloc.add(ChangeLangSubjectsEvent(
                                                  e.data()));
                                            },
                                            child: Ink(
                                              color:
                                                  e.data()[kdb_languageCode] ==
                                                          state.language![
                                                              kdb_languageCode]
                                                      ? Colors.grey[100]
                                                      : Colors.transparent,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
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
                              kSpacingWidth4,
                              Text(
                                '${state.language![kdb_languageName]} '
                                "(${state.countWithFilter})",
                                style: w500TextStyle(),
                              )
                            ],
                          ],
                        ),
                      ),
                      kSpacingWidth24,
                      InkWell(
                        onTap: () {
                          _bloc.add(ChangeFilterSubjectsEvent(
                              isForKid: !state.isForKid));
                        },
                        child: Row(
                          children: [
                            Text('isForKid:',
                                style: w300TextStyle(
                                    fontSize: 14, color: hexColor('#68686A'))),
                            kSpacingWidth4,
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
                      kSpacingWidth24,
                      InkWell(
                        onTap: () {
                          _bloc.add(ChangeFilterSubjectsEvent(
                              isPublic: !state.isPublic));
                        },
                        child: Row(
                          children: [
                            Text('isPublic:',
                                style: w300TextStyle(
                                    fontSize: 14, color: hexColor('#68686A'))),
                            kSpacingWidth4,
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
                  kSpacingWidth32,
                  Text(
                    'Page:',
                    style: w400TextStyle(),
                  ),
                  kSpacingWidth4,
                  IconButton(
                    onPressed: state.page == 1
                        ? null
                        : () {
                            _bloc.add(FetchSubjectsEvent(page: state.page - 1));
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
                            _bloc.add(FetchSubjectsEvent(page: state.page + 1));
                          },
                    icon: Icon(
                      Icons.chevron_right_rounded,
                      color: state.page * state.limit >= state.count
                          ? appColorElement
                          : appColorText,
                    ),
                  ),
                  kSpacingWidth12,
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
                                      _bloc.add(FetchSubjectsEvent(
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
                        kSpacingWidth4,
                        Text(
                          '${state.limit} items',
                          style: w500TextStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              kSpacingHeight32,
              Expanded(
                child: Column(
                  children: [
                    WidgetRowHeader(
                      child: Row(
                        children: const [
                          WidgetRowValue.label(flex: 2, value: kdb_id),
                          WidgetRowValue.label(flex: 1, value: kdb_order),
                          WidgetRowValue.label(flex: 2, value: kdb_imageUrl),
                          WidgetRowValue.label(flex: 2, value: kdb_label),
                          WidgetRowValue.label(flex: 7, value: kdb_sortDesc),
                          WidgetRowValue.label(value: kdb_questions),
                          WidgetRowValue.label(value: kdb_isForKid),
                          WidgetRowValue.label(value: kdb_isProVersion),
                          WidgetRowValue.label(value: kdb_isPublic),
                          WidgetRowValue.label(flex: 1, value: ''),
                        ],
                      ),
                    ),
                    kSpacingHeight20,
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: searchController,
                        builder: (context, value, child) {
                          String keyword = value.text;
                          List<QueryDocumentSnapshot<Map>> items = List.from(
                              (state.items ?? []).where((e) =>
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
                                      flex: 2,
                                      value: e.data()[kdb_id],
                                      maxLines: 99,
                                    ),
                                    WidgetRowValue(
                                      flex: 1,
                                      value: e.data()[kdb_order] ?? 999,
                                      maxLines: 99,
                                    ),
                                    WidgetRowValue(
                                      flex: 2,
                                      valueEdit: e.data()[kdb_imageUrl] ==
                                                  null ||
                                              e.data()[kdb_imageUrl]!.isEmpty
                                          ? '...'
                                          : e.data()[kdb_imageUrl],
                                      value: e.data()[kdb_imageUrl] == null ||
                                              e.data()[kdb_imageUrl]!.isEmpty
                                          ? '...'
                                          : AspectRatio(
                                              aspectRatio: 1,
                                              child: WidgetAppImage(
                                                  imageUrl:
                                                      e.data()[kdb_imageUrl]),
                                            ),
                                      maxLines: 99,
                                      callback: (value) async {
                                        await colSubjects
                                            .doc('${e.data()[kdb_id]}')
                                            .update({kdb_imageUrl: value});
                                        _bloc.add(const FetchSubjectsEvent());
                                      },
                                    ),
                                    WidgetRowValue(
                                      flex: 2,
                                      value: e.data()[kdb_label],
                                      maxLines: 99,
                                      callback: (value) async {
                                        await colSubjects
                                            .doc('${e.data()[kdb_id]}')
                                            .update({kdb_label: value});
                                        _bloc.add(const FetchSubjectsEvent());
                                      },
                                    ),
                                    WidgetRowValue(
                                      flex: 7,
                                      value: e.data()[kdb_sortDesc],
                                      maxLines: 99,
                                      callback: (value) async {
                                        await colSubjects
                                            .doc('${e.data()[kdb_id]}')
                                            .update({kdb_sortDesc: value});
                                        _bloc.add(const FetchSubjectsEvent());
                                      },
                                    ),
                                    WidgetRowValue(
                                      flex: 1,
                                      value: _NumberOfSubjects(
                                          id: e.data()[kdb_id]),
                                    ),
                                    WidgetRowValue(
                                      flex: 1,
                                      maxLines: 99,
                                      cellDataType: CellDataType.bol,
                                      value: e.data()[kdb_isForKid] ?? false,
                                      label: 'Set to isForKid',
                                      callback: (value) async {
                                        await colSubjects
                                            .doc('${e.data()[kdb_id]}')
                                            .update({kdb_isForKid: value});
                                        _bloc.add(const FetchSubjectsEvent());
                                      },
                                    ),
                                    WidgetRowValue(
                                      flex: 1,
                                      cellDataType: CellDataType.bol,
                                      value:
                                          e.data()[kdb_isProVersion] ?? false,
                                      label: 'Set to isProVersion',
                                      callback: (value) async {
                                        await colSubjects
                                            .doc('${e.data()[kdb_id]}')
                                            .update({kdb_isProVersion: value});
                                        _bloc.add(const FetchSubjectsEvent());
                                      },
                                    ),
                                    WidgetRowValue(
                                      flex: 1,
                                      maxLines: 99,
                                      cellDataType: CellDataType.bol,
                                      value: e.data()[kdb_isPublic],
                                      label: 'Set to isPublic',
                                      callback: (value) async {
                                        await colSubjects
                                            .doc('${e.data()[kdb_id]}')
                       .update({kdb_isPublic: value});
                                        _bloc.add(const FetchSubjectsEvent());
                                      },
                                    ),
                                    WidgetRowValue(
                                      flex: 1,
                                      value: WidgetDeleteButton(
                                        callback: () async {
                                          await colSubjects
                                              .doc('${e.data()[kdb_id]}')
                                              .delete();
                                          _bloc.add(const FetchSubjectsEvent());
                                          Get.find<QuizsBloc>().needRefresh();
                                          var queries = await colQuizs
                                              .where(kdb_subjectId,
                                                  isEqualTo: e.data()[kdb_id])
                                              .get();
                                          for (var doc in queries.docs) {
                                            colQuizs.doc(doc.id).delete();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NumberOfSubjects extends StatefulWidget {
  final int id;
  const _NumberOfSubjects({super.key, required this.id});

  @override
  State<_NumberOfSubjects> createState() => __NumberOfSubjectsState();
}

class __NumberOfSubjectsState extends State<_NumberOfSubjects> {
  int count = 0;
  _getCount() async {
    AggregateQuerySnapshot query =
        await colQuizs.where(kdb_subjectId, isEqualTo: widget.id).count().get();
    count = query.count;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$count',
      overflow: TextOverflow.ellipsis,
      style: w300TextStyle(),
    );
  }
}
