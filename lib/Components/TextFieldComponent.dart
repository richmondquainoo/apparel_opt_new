import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldComponent extends StatelessWidget {
  final Icon? prefixIcon;
  final String? hint;
  final bool? obscureText;
  final bool? enableField;
  final TextEditingController? controller;
  final Function? onChange;
  const TextFieldComponent({
    @required this.prefixIcon,
    @required this.hint,
    @required this.obscureText,
    this.enableField,
    this.controller,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // onChanged: onChange,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: enableField,
      obscureText: obscureText!,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hint,
        hintStyle: GoogleFonts.roboto(
          color: Colors.black54,
        ),
        // contentPadding: const EdgeInsets.only(left: 5.0, bottom: 16),
      ),
    );
  }
}
