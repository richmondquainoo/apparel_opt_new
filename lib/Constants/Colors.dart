// ignore_for_file: constant_identifier_names, file_names

import 'package:flutter/material.dart';

const WHITE_COLOR = Colors.white;
const HARMONY_GREEN = Color(0xFF68BD27);
const LIFE_GREEN = Color(0xFF167E1B);
const BACKGROUND_COLOR = Color(0xFFe7eaf3);
const GREEN_GRADIENT = Color(0xFF6CF8D6);
const APPBAR_GREEN = Color(0xFF017174);
const LIGHT_RED_COLOR = Color(0xFFFFA8A8);
const PRIMARY_YELLOW = Color(0xFFF8B400);
const PRIMARY_BLACK = Color(0xFF141E27);
const DEEP_YELLOW = Color(0xFFFFC300);
const NAVBAR_BACKGROUND_COLOR = Color(0xFFe7eaf3);

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
