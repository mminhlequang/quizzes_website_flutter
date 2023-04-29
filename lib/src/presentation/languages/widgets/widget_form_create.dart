import 'dart:convert';

import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';
import 'package:quizzes/src/presentation/widgets/widget_button.dart';
import 'package:quizzes/src/presentation/widgets/widget_check.dart';
import 'package:quizzes/src/presentation/widgets/widget_textfield.dart';

import '../bloc/languages_bloc.dart';

LanguagesBloc get _bloc => Get.find<LanguagesBloc>();

class WidgetFormCreateLangs extends StatefulWidget {
  const WidgetFormCreateLangs({super.key});

  @override
  State<WidgetFormCreateLangs> createState() => _WidgetFormCreateLangsState();
}

class _WidgetFormCreateLangsState extends State<WidgetFormCreateLangs> {
  final TextEditingController json = TextEditingController();
  final TextEditingController title = TextEditingController();
  final TextEditingController code = TextEditingController();
  bool isSetPublic = true;
  bool isEnableJson = false;
  bool get isJson {
    var r;
    try {
      if (json.text.isNotEmpty) r = jsonDecode(json.text.trim());
    } catch (e) {}
    return r != null;
  }

  _submit(data) async {
    await colLangs.doc('${data[kdb_languageCode]}').set(data);
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
            tag: 'WidgetFormCreateLangs',
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
                            "Languages",
                            style: w600TextStyle(fontSize: 28),
                          ),
                          kSpacingHeight8,
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
                          kSpacingHeight24,
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
                                  await _submit(e);
                                }
                              } else {
                                await _submit({
                                  kdb_languageName: title.text.trim(),
                                  kdb_languageCode: code.text.trim(),
                                  kdb_isPublic: isSetPublic,
                                });
                              }
                              _bloc.add(const FetchLanguagesEvent(page: 1));
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
