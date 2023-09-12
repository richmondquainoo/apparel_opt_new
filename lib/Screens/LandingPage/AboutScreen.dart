import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/constantColors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        title: Text(
          "About",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 19,
            color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60,
                    backgroundImage: AssetImage(
                      'assets/images/appLogo.png',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                  ),
                  Text(
                    "Date created: 12/08/2022",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w300,
                        fontSize: 13.0,
                        color: LABEL_COLOR,
                        letterSpacing: 0.8),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 13.0),
                  ),
                  Text(
                    "\u00a9 2022 DataRun Inc.",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                        color: Colors.teal,
                        letterSpacing: 0.5),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 13.0),
                  ),
                  Text(
                    "Version 1.0.3",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w300,
                        fontSize: 13.0,
                        color: LABEL_COLOR,
                        letterSpacing: 0.8),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
