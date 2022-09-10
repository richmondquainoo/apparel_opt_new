import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/Colors.dart';
import 'WidgetFunctions.dart';

class DashboardCardComponent extends StatelessWidget {
  final String dashboardLabel;
  final String dashboardDescription;
  final String subLabel;
  final String subDescription;
  final String dashboardIcon;
  final Color firstGradientColor;
  final Color secondGradientColor;

  const DashboardCardComponent(
      {Key key,
      this.dashboardLabel,
      this.dashboardDescription,
      this.subLabel,
      this.subDescription,
      this.dashboardIcon,
      this.firstGradientColor,
      this.secondGradientColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 207,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14), color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                  topLeft: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    firstGradientColor,
                    secondGradientColor,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 35,
                          width: 40,
                          child: Image.asset(dashboardIcon),
                        ),
                      ),
                    ),
                    addVerticalSpace(10),
                    Text(
                      dashboardDescription ?? " ",
                      style: GoogleFonts.raleway(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    addVerticalSpace(5),
                    Text(
                      dashboardLabel,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 3),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subDescription,
                    style: GoogleFonts.raleway(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  addVerticalSpace(1),
                  Center(
                    child: Text(
                      subLabel,
                      style: GoogleFonts.raleway(
                        color: APPBAR_GREEN,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
