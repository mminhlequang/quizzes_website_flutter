import 'package:_iwu_pack/_iwu_pack.dart';
import 'package:flutter/material.dart';

import '../models/country_model.dart';

/// [Item]
class Item extends StatelessWidget {
  final Widget Function(String)? builder;
  final Country? country;
  final TextStyle? textStyle;
  final double? leadingPadding;
  final bool trailingSpace;

  const Item({
    super.key,
    this.builder,
    this.country,
    this.textStyle,
    this.leadingPadding = 12,
    this.trailingSpace = true,
  });

  @override
  Widget build(BuildContext context) {
    String dialCode = (country?.dialCode ?? '');
    if (trailingSpace) {
      dialCode = dialCode.padRight(5, "   ");
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(width: leadingPadding),
        _Flag(
          builder: builder,
          country: country,
        ),
        SizedBox(width: leadingPadding),
        Text(
          dialCode,
          textDirection: TextDirection.ltr,
          style: textStyle,
        ),
      ],
    );
  }
}

class _Flag extends StatelessWidget {
  final Widget Function(String)? builder;
  final Country? country;

  const _Flag({this.builder, this.country});

  @override
  Widget build(BuildContext context) {
    return country != null
        ? builder != null
            ? builder!(country!.alpha2Code!)
            : WidgetAppFlag.countryCode(
                countryCode: country!.alpha2Code!,
                height: 24.0,
                errorBuilder: const SizedBox.shrink())
        : const SizedBox.shrink();
  }
}
