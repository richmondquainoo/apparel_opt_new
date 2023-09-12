import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/Colors.dart';

class InstitutionCards extends StatelessWidget {
  final String? institutionName;
  final String? industry;
  final String? imageURL;
  final Function? onTapped;
  const InstitutionCards(
      {@required this.institutionName,
      @required this.industry,
      @required this.imageURL,
      @required this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 70,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: (){
            onTapped;
          },
          child: ListTile(
            title: Text(
              institutionName!,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w500,
                  color: APPBAR_GREEN,
                  fontSize: 14),
            ),
            subtitle: Text(
              industry!,
              style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w200,
                  color: APPBAR_GREEN,
                  fontSize: 13),
            ),
            leading: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imageURL!),
                ),
              ),
            ),
            trailing: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(
                Icons.arrow_drop_down_outlined,
                color: APPBAR_GREEN,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
