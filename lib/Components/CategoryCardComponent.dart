import 'package:apparel_options/Screens/T-ShirtScreen.dart';
import 'package:flutter/material.dart';

import '../Constants/Colors.dart';

class CategoryCardComponent extends StatelessWidget {
  final String? backgroundImage;
  final String? category;
  final String? icon;
  final Function? onTapped;

  const CategoryCardComponent(
      {this.backgroundImage, this.category, this.icon, this.onTapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0, right: 11, top: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TShirtScreen()));
        },
        child: Container(
          height: 165,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              offset: Offset(0.3, 0.3),
              color: Colors.black54,
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.37), BlendMode.darken),
                      image: AssetImage(
                        backgroundImage!,
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7.0, bottom: 7),
                child: Container(
                  child: Text(
                    category!,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: APPBAR_GREEN,
                        letterSpacing: 0.6),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
