import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';

class WidgetCheck extends StatelessWidget {
  final bool status;
  final String label;
  final ValueChanged? callback;
  const WidgetCheck(
      {super.key, required this.status, required this.label, this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback != null
          ? () {
              callback?.call(!status);
            }
          : null,
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: status ? appColorPrimary : appColorElement,
            child: status
                ? const Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
          ),
          kSpacingWidth8,
          Text(
            label,
            style: w400TextStyle(),
          )
        ],
      ),
    );
  }
}
