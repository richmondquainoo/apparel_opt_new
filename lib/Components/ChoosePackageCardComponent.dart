// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/Colors.dart';
import '../Constants/myColors.dart';
import 'WidgetFunctions.dart';

class ChoosePackageCardComponent extends StatelessWidget {
  final String packageLabel;
  final String packageDescription;
  final String amount;
  const ChoosePackageCardComponent({
    this.packageLabel,
    this.packageDescription,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.225,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: kCardBackGround),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 26,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HARMONY_GREEN,
                    GREEN_GRADIENT,
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  "Free 30 Day Trial",
                  style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ),
          addVertical(4),
          Container(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          packageLabel,
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      addVertical(7.5),
                      Container(
                        child: Text(
                          packageDescription,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                addHorizontal(7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          '\$$amount',
                          style: GoogleFonts.raleway(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      addVertical(7.5),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const ActionsScreen(),
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 30,
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: APPBAR_GREEN,
                            ),
                            child: Center(
                              child: Text(
                                "Start Free Trial",
                                style: GoogleFonts.lato(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
