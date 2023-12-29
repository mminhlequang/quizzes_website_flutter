import 'dart:convert';

import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';
import 'package:quizzes/src/presentation/quizs/bloc/quizs_bloc.dart';
import 'package:quizzes/src/presentation/widgets/widget_button.dart';
import 'package:quizzes/src/presentation/widgets/widget_check.dart';
import 'package:quizzes/src/presentation/widgets/widget_textfield.dart';

import '../bloc/subjects_bloc.dart';

SubjectsBloc get _bloc => Get.find<SubjectsBloc>();

class WidgetFormCreateSubjects extends StatefulWidget {
  const WidgetFormCreateSubjects({super.key});

  @override
  State<WidgetFormCreateSubjects> createState() =>
      _WidgetFormCreateSubjectsState();
}

class _WidgetFormCreateSubjectsState extends State<WidgetFormCreateSubjects> {
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

  _submit(Map<String, dynamic> data) async {
    var id = DateTime.now().millisecondsSinceEpoch;
    data.addAll({kdb_id: id});
    await colSubjects.doc('$id').set(data);
    Get.find<QuizsBloc>().needRefresh();
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
            tag: 'WidgetFormCreateSubjects',
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
                      duration: Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Subjects",
                            style: w600TextStyle(fontSize: 28),
                          ),
                          Gap(8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  icon: WidgetAppSVG(
                                    assetsvg('json'),
                                    width: 24,
                                  )),
                            ],
                          ),
                          Gap(24),
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
                                Gap(16),
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
                            Gap(16),
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
                          Gap(24),
                          WidgetButton(
                            enable: isEnableJson
                                ? isJson
                                : title.text.isNotEmpty && code.text.isNotEmpty,
                            label: 'Submit',
                            onTap: () async {
                              Get.back();
                              if (isEnableJson) {
                                List datas =
                                    jsonDecode(json.text.trim()) as List;
                                for (var e in datas) {
                                  await _submit(Map<String, dynamic>.from(e));
                                }
                              } else {
                                await _submit({
                                  kdb_languageName: title.text.trim(),
                                  kdb_languageCode: code.text.trim(),
                                  kdb_isPublic: isSetPublic,
                                });
                              }
                              _bloc.add(const FetchSubjectsEvent(page: 1));
                            },
                          )
                        ],
                      ),
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
