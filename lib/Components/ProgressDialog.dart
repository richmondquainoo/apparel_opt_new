
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class ProgressDialog extends StatelessWidget {
  final String displayMessage;

  ProgressDialog({@required this.displayMessage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text(
                displayMessage,
                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
