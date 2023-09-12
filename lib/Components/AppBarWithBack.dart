// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/Colors.dart';
import '../Constants/myColors.dart';

AppBar AppBarWithBackComponent({BuildContext? context, String? title}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      onPressed: () => Navigator.pop(context!),
      icon: const Icon(
        Icons.navigate_before,
        color: BLACK_COLOR,
        size: 40,
      ),
    ),
    title: Text(
      title!,
      style: GoogleFonts.raleway(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: APPBAR_GREEN,
        letterSpacing: .75,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/logo.jpeg', height: 70),
      ),
    ],
  );
}
