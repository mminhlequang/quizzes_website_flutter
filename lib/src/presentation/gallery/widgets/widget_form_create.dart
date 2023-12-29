
import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:browser_image_compression/browser_image_compression.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quizzes/src/firestore_resources/firestore_resources.dart';
import 'package:quizzes/src/presentation/widgets/widget_button.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:quizzes/src/utils/utils.dart';

import '../bloc/gallery_bloc.dart';

GalleryBloc get _bloc => Get.find<GalleryBloc>();

class WidgetFormCreateLangs extends StatefulWidget {
  const WidgetFormCreateLangs({super.key});

  @override
  State<WidgetFormCreateLangs> createState() => _WidgetFormCreateLangsState();
}

class _WidgetFormCreateLangsState extends State<WidgetFormCreateLangs> {
  bool isDraging = false;
  List<XFile> xfiles = [];
  bool loading = false;

  onPickToUpload() async {
    final pickedFile = await ImagePicker().pickMultiImage();
    if (pickedFile.isNotEmpty) {
      xfiles = pickedFile;
      setState(() {});
    }
  }

  _submit() async {
    setState(() {
      loading = true;
    });
    for (var xfile in xfiles) {
      //Compress
      Uint8List data = await BrowserImageCompression.compressImage(
        basename(xfile.name), // or xfile.name
        await xfile.readAsBytes(),
        lookupMimeType(xfile.name).toString(),
        Options(
          maxSizeMB: .4,
          maxWidthOrHeight: 768,
          useWebWorker: true,
          onProgress: (progress) {
            print('Compress: $progress');
          },
        ),
      );

      //Upload
      // Create the file metadata
      final metadata =
          SettableMetadata(contentType: lookupMimeType(xfile.name));
      Reference imagesRef = refGalleryImages.child(xfile.name);
      final uploadTask = imagesRef.putData(data, metadata);

      // Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print('Upload: $progress');
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            // Handle successful uploads on complete
            // ...

            int id = DateTime.now().millisecondsSinceEpoch;
            String? getDownloadURL = await imagesRef.getDownloadURL();
            print("Upload was success: $getDownloadURL");
            Map data = {
              kdb_id: id,
              kdb_url: getDownloadURL,
              kdb_mime: lookupMimeType(xfile.name),
              kdb_fileName: xfile.name,
              kdb_size: taskSnapshot.totalBytes,
              kdb_path: refGalleryImages.fullPath,
            };
            colGallery.doc('$id').set(Map<String, dynamic>.from(data));
            break;
        }
      });
      await uploadTask;
    }

    await Future.delayed(const Duration(seconds: 1));
    _bloc.add(const FetchGalleryEvent(page: 1));
    Get.back();
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
                  width: 500,
                  decoration: BoxDecoration(
                      color: appColorBackground,
                      borderRadius: BorderRadius.circular(26)),
                  child: SingleChildScrollView(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Gallery",
                            style: w600TextStyle(fontSize: 28),
                          ),
                          const Gap(8),
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
                                onPressed: onPickToUpload,
                                icon: Icon(
                                  CupertinoIcons.cloud_upload_fill,
                                  color: appColorText,
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          DropTarget(
                            onDragDone: (detail) {
                              if (detail.files
                                  .where((e) => isImageByMime(e.mimeType))
                                  .isNotEmpty) {
                                xfiles = detail.files
                                    .where((e) => isImageByMime(e.mimeType))
                                    .toList();
                                setState(() {});
                              }
                            },
                            onDragEntered: (detail) {
                              setState(() {
                                isDraging = true;
                              });
                            },
                            onDragExited: (detail) {
                              setState(() {
                                isDraging = false;
                              });
                            },
                            child: InkWell(
                              onTap: onPickToUpload,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(26),
                                padding: const EdgeInsets.all(5),
                                dashPattern: const [8, 8],
                                color: hexColor('#B8B8B8'),
                                strokeWidth: 2,
                                child: SizedBox(
                                  height: 160,
                                  child: Center(
                                      child: isDraging
                                          ? Text(
                                              'drophere!'.tr,
                                              style: w400TextStyle(
                                                  fontSize: 20,
                                                  color: appColorPrimary),
                                            )
                                          : const Icon(
                                              CupertinoIcons.cloud_upload,
                                              color: Colors.grey,
                                              size: 48,
                                            )),
                                ),
                              ),
                            ),
                          ),
                          const Gap(20),
                          ...xfiles
                              .mapIndexed((e, i) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          '$i. ${e.name} (${e.mimeType})',
                                          style: w300TextStyle(),
                                        ))
                                      ],
                                    ),
                                  ))
                              ,
                          const Gap(24),
                          WidgetButton(
                            loading: loading,
                            enable: xfiles.isNotEmpty,
                            label: 'Submit',
                            onTap: _submit,
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
