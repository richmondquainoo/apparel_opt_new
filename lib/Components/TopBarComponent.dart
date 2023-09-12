
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/constantColors.dart';




class TopBarComponent extends StatelessWidget {
  final Icon? icon;
  final String? label;
  final Function? iconFunction;
  final Function? labelFunction;

  TopBarComponent({
    @required this.icon,
    this.label,
    @required this.iconFunction,
    this.labelFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  iconFunction;
                },
                child: Container(
                  child: icon,

                ),
              ),
              GestureDetector(
                // onTap: labelFunction != null ? labelFunction : (){},
                child: Container(
                  child: Text(
                    label! != null ? label! : "",
                    style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kButtonColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
