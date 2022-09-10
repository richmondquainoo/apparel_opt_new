import 'package:apparel_options/Screens/GettingStarted/NewLoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Components/TextButtonComponent.dart';
import '../../Constants/Colors.dart';
import '../../Constants/constantColors.dart';

class GettingStartedScreen extends StatefulWidget {
  const GettingStartedScreen({Key key}) : super(key: key);

  @override
  State<GettingStartedScreen> createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/backgroungImg.jpg",
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 220,
              ),
              decoration: BoxDecoration(
                color: BLACK_COLOR.withOpacity(0.35),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    "assets/images/appLogo.png",
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Center(
                        child: Text(
                          "Apparel",
                          style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: PRIMARY_YELLOW,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          "Options",
                          style: GoogleFonts.raleway(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          BottomButton(),
        ],
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 58.0, left: 20, right: 20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 1.0,
                right: 1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        'Welcome to Apparel Options. We provide you with high quality '
                        "collections of T-Shirts and other related products from the best brands around the globe"
                        '!',
                        style: GoogleFonts.raleway(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.5,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextButtonComponent(
              fontSize: 17,
              label: "Get Started",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewLoginScreen()));
              },
              borderRadius: 8,
              labelColor: PRIMARY_YELLOW,
              textColor: PRIMARY_BLACK,
              fontWeight: FontWeight.w700,
              buttonHeight: 54,
            ),
          ],
        ),
      ),
    );
  }
}
