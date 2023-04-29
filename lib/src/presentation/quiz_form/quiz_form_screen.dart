import 'dart:convert';
import 'dart:math';

import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';
import 'package:quizzes/src/presentation/widgets/widget_button.dart';
import 'package:quizzes/src/presentation/widgets/widget_check.dart';
import 'package:quizzes/src/presentation/widgets/widget_textfield.dart';

import '../quizs/bloc/quizs_bloc.dart';
import '../widgets/widget_popup_container.dart';
import 'bloc/quiz_form_bloc.dart';

QuizFormBloc get _bloc => Get.find<QuizFormBloc>();

class QuizFormScreen extends StatefulWidget {
  const QuizFormScreen({super.key});

  @override
  State<QuizFormScreen> createState() => _QuizFormScreenState();
}

class _QuizFormScreenState extends State<QuizFormScreen> {
  final TextEditingController json = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController code = TextEditingController();
  bool isSetPublic = true;
  bool isEnableJson = true;
  bool get isJson {
    var r;
    try {
      if (json.text.isNotEmpty) r = jsonDecode(json.text.trim());
    } catch (e) {}
    return r != null;
  }

  _submit(Map<String, dynamic> data, subjectId) async {
    var id = DateTime.now().millisecondsSinceEpoch;
    data.addAll({kdb_id: id, kdb_subjectId: subjectId});
    await colQuizs.doc('$id').set(data);
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(InitQuizFormEvent());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Material(
        color: Colors.black26,
        child: Center(
          child: Hero(
            tag: 'WidgetFormCreateQuizs',
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(32),
                  width: 600,
                  decoration: BoxDecoration(
                      color: appColorBackground,
                      borderRadius: BorderRadius.circular(26)),
                  child: SingleChildScrollView(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: BlocBuilder<QuizFormBloc, QuizFormState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Quizs",
                                  style: w600TextStyle(fontSize: 28),
                                ),
                                kSpacingHeight8,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "New item",
                                      style: w400TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isEnableJson = !isEnableJson;
                                        });
                                      },
                                      icon: Opacity(
                                        opacity: isEnableJson ? 1 : .6,
                                        child: WidgetAppSVG(
                                          assetsvg('json'),
                                          width: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                kSpacingHeight24,
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
                                          top: childPosition.dy +
                                              size.height +
                                              8,
                                          child: WidgetPopupContainer(
                                            alignmentTail: Alignment.topLeft,
                                            paddingTail:
                                                const EdgeInsets.only(left: 16),
                                            child: Container(
                                              width: 120,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Column(
                                                  children: state.itemsLangs!
                                                      .map(
                                                        (e) => InkWell(
                                                          onTap: () {
                                                            hide();
                                                            _bloc.add(
                                                                ChangeLangQuizFormEvent(
                                                                    e.data()));
                                                          },
                                                          child: Ink(
                                                            color: e.data()[
                                                                        kdb_languageCode] ==
                                                                    state.language![
                                                                        kdb_languageCode]
                                                                ? Colors
                                                                    .grey[100]
                                                                : Colors
                                                                    .transparent,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 8,
                                                                    horizontal:
                                                                        16),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                '${e.data()[kdb_languageName]}',
                                                                style:
                                                                    w400TextStyle(),
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
                                                    color:
                                                        hexColor('#68686A'))),
                                            kSpacingWidth4,
                                            Text(
                                              '${state.language![kdb_languageName]}',
                                              style: w500TextStyle(),
                                            )
                                          ],
                                        ],
                                      ),
                                    ),
                                    kSpacingWidth24,
                                    InkWell(
                                      onTap: () {
                                        _bloc.add(ChangeFilterQuizFormEvent(
                                            isForKid: !state.isForKid));
                                      },
                                      child: Row(
                                        children: [
                                          Text('isForKid:',
                                              style: w300TextStyle(
                                                  fontSize: 14,
                                                  color: hexColor('#68686A'))),
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
                                          top: childPosition.dy +
                                              size.height +
                                              8,
                                          child: WidgetPopupContainer(
                                            alignmentTail: Alignment.topLeft,
                                            paddingTail:
                                                const EdgeInsets.only(left: 16),
                                            child: Container(
                                              width: 120,
                                              height: min(
                                                  260,
                                                  state.itemsSubjects!.length *
                                                          24 +
                                                      12 * 2),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: state
                                                        .itemsSubjects!
                                                        .map(
                                                          (e) => InkWell(
                                                            onTap: () {
                                                              hide();
                                                              _bloc.add(
                                                                  ChangeSubjectQuizFormEvent(
                                                                      e.data()));
                                                            },
                                                            child: Ink(
                                                              color: e.data()[kdb_id] ==
                                                                      state.subject![
                                                                          kdb_id]
                                                                  ? Colors
                                                                      .grey[100]
                                                                  : Colors
                                                                      .transparent,
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 8,
                                                                  horizontal:
                                                                      16),
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  '${e.data()[kdb_label]}',
                                                                  style:
                                                                      w400TextStyle(),
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
                                                    color:
                                                        hexColor('#68686A'))),
                                            kSpacingWidth4,
                                            Text(
                                              '${state.subject![kdb_label]}',
                                              style: w500TextStyle(),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                kSpacingHeight16,
                                if (isEnableJson) ...[
                                  WidgetTextField(
                                    controller: json,
                                    label: 'Json format',
                                    maxLines: 15,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ] else ...[
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: WidgetTextField(
                                            controller: title,
                                            label: 'Display name',
                                            onChanged: (value) {
                                              setState(() {});
                                            },
                                          )),
                                      kSpacingWidth16,
                                      Expanded(
                                        flex: 1,
                                        child: WidgetTextField(
                                          controller: code,
                                          label: 'Language code',
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  kSpacingHeight16,
                                  WidgetCheck(
                                    status: isSetPublic,
                                    label: 'Set to public',
                                    callback: (value) {
                                      setState(() {
                                        isSetPublic = !isSetPublic;
                                      });
                                    },
                                  )
                                ],
                                kSpacingHeight24,
                                WidgetButton(
                                  enable: state.subject != null &&
                                      (isEnableJson
                                          ? isJson
                                          : title.text.isNotEmpty &&
                                              code.text.isNotEmpty),
                                  label: 'Submit',
                                  onTap: () async {
                                    Get.back();
                                    if (isEnableJson) {
                                      List datas =
                                          jsonDecode(json.text.trim()) as List;
                                      for (var e in datas) {
                                        await _submit(
                                            Map<String, dynamic>.from(e),
                                            state.subject![kdb_id]);
                                      }
                                    } else {
                                      await _submit({
                                        kdb_languageName: title.text.trim(),
                                        kdb_languageCode: code.text.trim(),
                                        kdb_isPublic: isSetPublic,
                                      }, state.subject![kdb_id]);
                                    }
                                    Get.find<QuizsBloc>()
                                        .add(const FetchQuizsEvent(page: 1));
                                  },
                                )
                              ],
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
