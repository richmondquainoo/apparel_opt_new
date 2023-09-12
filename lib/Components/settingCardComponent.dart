import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'WidgetFunctions.dart';

class SettingCardComponent extends StatelessWidget {
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? bgIconColor;
  final String? title;
  final GestureTapCallback? onTap;
  const SettingCardComponent(
      {@required this.title,
      this.onTap,
      this.leadingIcon,
      this.leadingIconColor = Colors.white,
      this.bgIconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: leadingIcon != null
              ? [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: bgIconColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Icon(
                      leadingIcon,
                      size: 22,
                      color: leadingIconColor,
                    ),
                  ),
                  addHorizontalSpace(10),
                  Expanded(
                    child: Text(
                      title!,
                      style: GoogleFonts.raleway(fontSize: 14),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ]
              : [
                  Expanded(
                    child: Text(
                      title!,
                      style: GoogleFonts.raleway(fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 17,
                  ),
                ],
        ),
      ),
    );
  }
}
