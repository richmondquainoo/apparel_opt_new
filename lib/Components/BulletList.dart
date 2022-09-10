import 'package:apparel_options/Constants/constantColors.dart';
import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List<String> strings;

  BulletList(this.strings);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(2, 1, 1, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '\u2022',
                style: TextStyle(
                  fontSize: 15,
                  color: LABEL_COLOR,
                  height: 1.4,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  child: Text(
                    str,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
