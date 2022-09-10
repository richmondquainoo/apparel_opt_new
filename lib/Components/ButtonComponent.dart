// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/Colors.dart';

ElevatedButton ButtonComponent(
  BuildContext context,
  String name,
  Function onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      primary: APPBAR_GREEN,
    ),
    child: Align(
      alignment: Alignment.center,
      child: Text(
        name,
        style: GoogleFonts.raleway(
          color: WHITE_COLOR,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
