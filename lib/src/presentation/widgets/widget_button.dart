import 'package:_imagineeringwithus_pack/_imagineeringwithus_pack.dart';
import 'package:flutter/material.dart';

class WidgetButton extends StatelessWidget {
  final bool enable;
  final bool loading;
  final String label;
  final VoidCallback? onTap;
  const WidgetButton(
      {super.key,
      this.enable = true,
      this.loading = false,
      required this.label,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enable || loading ? null : onTap,
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: enable ? appColorText : appColorElement),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: appColorPrimary,
                    ),
                  )
                : Text(
                    label,
                    style: w400TextStyle(color: appColorBackground),
                  ),
          ),
        ),
      ),
    );
  }
}
