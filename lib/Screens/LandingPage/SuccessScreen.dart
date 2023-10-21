import 'package:apparel_options/Screens/LandingPage/OrderScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../animation/FadeAnimation.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: MaterialButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderScreen(
                        showBackButton: true,
                      )));
            },
            height: 50,
            elevation: 0,
            splashColor: Colors.yellow[700],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            color: Colors.black,
            child: Center(
              child: Text(
                "Track My Order",
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        )
      ],
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
        automaticallyImplyLeading: false,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: const Icon(Icons.close, size: 24, color: Colors.black54),
        //   ),
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 210,
                    child: Lottie.network(
                        "https://lottie.host/c9eabe4f-b6ec-4083-99a5-5cfbe4e51c02/gtGTGaSuDH.json"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Thank You",
                    style: GoogleFonts.raleway(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your order placement is successful !!!",
                    style: GoogleFonts.raleway(
                        color: Colors.teal,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
