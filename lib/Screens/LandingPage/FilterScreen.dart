import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/constantColors.dart';
import '../../Constants/myColors.dart';
import '../../animation/FadeAnimation.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  var selectedRange = const RangeValues(10, 100);

  List<Color> colors = [
    Colors.black,
    Colors.purple,
    Colors.orange.shade200,
    Colors.blueGrey,
    Colors.red,
    Colors.teal,
    Color(0xFFFFC1D9),
  ];

  int _selectedColor = 0;
  int _selectedSize = 0;
  int _selectedCategory = 0;

  List<String> size = [
    "XS",
    "S",
    "M",
    "L",
    "XL",
  ];

  List<String> category = ["All", "Men", "Ladies", "Kids", "Unisex"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 160,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Center(
                      child: Text(
                        "Discard",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.7,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.all(3.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 160,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black),
                    child: Center(
                      child: Text(
                        "Apply",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          letterSpacing: 0.7,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        )
      ],
      backgroundColor: kBackgroundTheme,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0.3,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:
              const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black54),
        ),
        title: Text(
          "Filters",
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: .75,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Price Range",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: LABEL_COLOR),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18.0, right: 18, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GHS ${selectedRange.start.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        // const SizedBox(
                        //   width: 100,
                        // ),
                        Text(
                          'GHS ${selectedRange.end.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: RangeSlider(
                        values: selectedRange,
                        min: 10.00,
                        max: 100.00,
                        divisions: 100,
                        inactiveColor: Colors.grey.shade300,
                        activeColor: Colors.teal,
                        labels: RangeLabels(
                          '\$ ${selectedRange.start.toStringAsFixed(2)}',
                          '\$ ${selectedRange.end.toStringAsFixed(2)}',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() => selectedRange = values);
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Colors",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: LABEL_COLOR),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: _selectedColor == index
                                      ? colors[index]
                                      : colors[index].withOpacity(0.5),
                                  shape: BoxShape.circle),
                              width: 30,
                              height: 30,
                              child: Center(
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Sizes",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: LABEL_COLOR),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: size.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedSize = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: _selectedSize == index
                                      ? Colors.teal
                                      : Colors.grey.shade200,
                                  shape: BoxShape.circle),
                              width: 35,
                              height: 35,
                              child: Center(
                                child: Text(
                                  size[index],
                                  style: TextStyle(
                                      color: _selectedSize == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Category",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: LABEL_COLOR),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 37,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: _selectedCategory == index
                                      ? Colors.teal
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(7)),
                              width: 80,
                              height: 10,
                              child: Center(
                                child: Text(
                                  category[index],
                                  style: TextStyle(
                                      color: _selectedCategory == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Brands",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: LABEL_COLOR),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 65,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 22),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "Gildan",
                                    style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Colors.black),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.arrow_forward_ios,
                                        size: 18, color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
