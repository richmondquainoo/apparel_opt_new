import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorizontalTextComponent extends StatelessWidget {
  final String? label;
  final Color? userColor;
  final Color? backgroundColor;
  final double? borderRadius;

  const HorizontalTextComponent(
      {@required this.label,
      this.userColor,
      this.backgroundColor,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          border: Border.all(
            color: Colors.black12, //                   <--- border color
            width: 1.0,
          ),
          color: backgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Center(
          child: Text(label ?? "Label",
              style: GoogleFonts.actor(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: userColor ?? Colors.black,
                  letterSpacing: 0.2)),
        ),
      ),
    );
  }
}
