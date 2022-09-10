import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Components/BulletList.dart';
import '../Constants/constantColors.dart';
import '../Constants/myColors.dart';
import '../Model/ProductNew.dart';
import '../animation/FadeAnimation.dart';
import 'ProductDetails.dart';

class TShirtScreen extends StatefulWidget {
  const TShirtScreen({Key key}) : super(key: key);

  @override
  State<TShirtScreen> createState() => _TShirtScreenState();
}

class _TShirtScreenState extends State<TShirtScreen>
    with TickerProviderStateMixin {
  bool _isScrolled = false;
  ScrollController _scrollController;

  List<dynamic> productList = [];
  List<String> size = [
    "S",
    "M",
    "L",
    "XL",
  ];

  List<Color> colors = [
    Colors.black,
    Colors.purple,
    Colors.orange.shade200,
    Colors.blueGrey,
    Color(0xFFFFC1D9),
  ];

  int _selectedColor = 0;
  int _selectedSize = 1;

  var selectedRange = const RangeValues(150.00, 1500.00);

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    products();

    super.initState();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundTheme,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.22,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
            size: 40,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showFilterModal();
              // ViewAppointment(context);
            },
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
        title: Text(
          "T-Shirt",
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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30.0,
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black12, //                   <--- border color
                            width: 1.0,
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text("Men",
                              style: GoogleFonts.actor(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black12, //                   <--- border color
                            width: 1.0,
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text("Ladies",
                              style: GoogleFonts.actor(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black12, //                   <--- border color
                            width: 1.0,
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text("Unisex",
                              style: GoogleFonts.actor(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black12, //                   <--- border color
                            width: 1.0,
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text("Kids",
                              style: GoogleFonts.actor(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black12, //                   <--- border color
                            width: 1.0,
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text("V-Necks",
                              style: GoogleFonts.actor(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 0.2)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 40,
                      width: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors
                                .black12, //                   <--- border color
                            width: 1.0,
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Center(
                          child: Text("Crew Necks",
                              style: GoogleFonts.actor(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 0.2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 0, left: 10),
                height: 300,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Products',
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Text(
                          'See all ',
                          style: GoogleFonts.lato(
                              color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            return productCart(productList[index]);
                          }))
                ])),
            Container(
                padding: const EdgeInsets.only(top: 8, left: 10),
                height: 310,
                child: Column(children: [
                  FadeAnimation(
                      1.4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Products',
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              'See all ',
                              style: GoogleFonts.lato(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: demoProducts.length,
                          itemBuilder: (context, index) {
                            return productCart(demoProducts[index]);
                          }))
                ])),
            Container(
                padding: const EdgeInsets.only(top: 8, left: 10),
                height: 310,
                child: Column(children: [
                  FadeAnimation(
                      1.4,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Collections',
                            style: GoogleFonts.lato(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              'See all ',
                              style: GoogleFonts.lato(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: demoProducts.length,
                          itemBuilder: (context, index) {
                            return forYou(demoProducts[index]);
                          }))
                ])),
          ],
        ),
      ),
    );
  }

  Future<void> products() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);

    setState(() {
      productList = demoProducts;
    });
  }

  productCart(ProductNew product) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: FadeAnimation(
          1.5,
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetails(product: product)));
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(5, 10),
                    blurRadius: 15,
                    color: Colors.grey.shade200,
                  )
                ],
              ),
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(product.images[0],
                                  color: Colors.black12,
                                  colorBlendMode: BlendMode.darken,
                                  fit: BoxFit.cover)),
                        ),
                        // Add to cart button
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: MaterialButton(
                            color: Colors.teal,
                            minWidth: 40,
                            height: 40,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: () {
                              addToCartModal();
                            },
                            padding: EdgeInsets.all(5),
                            child: const Center(
                                child: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 20,
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Text(
                      product.title,
                      style: GoogleFonts.lato(
                          color: LABEL_COLOR,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.3),
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "GHc " + product.price.toString(),
                          style: GoogleFonts.lato(
                            color: LABEL_COLOR,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          product.description,
                          style: GoogleFonts.ibmPlexSans(
                              color: LABEL_COLOR,
                              fontSize: 14,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<dynamic> ViewAppointment(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 20),
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter',
                          style: GoogleFonts.raleway(
                              color: Colors.black,
                              fontSize: 1,
                              fontWeight: FontWeight.w700),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Color",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
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
                              width: 40,
                              height: 40,
                              child: Center(
                                child: _selectedColor == index
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Container(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Size',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
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
                                      ? Colors.yellow[800]
                                      : Colors.grey.shade200,
                                  shape: BoxShape.circle),
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Text(
                                  size[index],
                                  style: TextStyle(
                                      color: _selectedSize == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Slider Price Renge filter
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price Range',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '\$ ${selectedRange.start.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                            Text(" - ",
                                style: TextStyle(color: Colors.grey.shade500)),
                            Text(
                              '\$ ${selectedRange.end.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RangeSlider(
                        values: selectedRange,
                        min: 0.00,
                        max: 2000.00,
                        divisions: 100,
                        inactiveColor: Colors.grey.shade300,
                        activeColor: Colors.yellow[800],
                        labels: RangeLabels(
                          '\$ ${selectedRange.start.toStringAsFixed(2)}',
                          '\$ ${selectedRange.end.toStringAsFixed(2)}',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() => selectedRange = values);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    button('Filter', () {})
                  ],
                ),
              ),
            );
          });
        });
  }

  forYou(ProductNew product) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: FadeAnimation(
        1.5,
        Container(
          margin: const EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 15,
                color: Colors.grey.shade200,
              )
            ],
          ),
          padding: EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(product.images[0],
                              color: Colors.black12,
                              colorBlendMode: BlendMode.darken,
                              fit: BoxFit.cover)),
                    ),
                    // Add to cart button
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: MaterialButton(
                        color: Colors.teal,
                        minWidth: 40,
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          addToCartModal();
                        },
                        padding: EdgeInsets.all(5),
                        child: const Center(
                            child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Text(
                  product.title,
                  style: GoogleFonts.lato(
                      color: LABEL_COLOR,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      letterSpacing: 0.3),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.price.toString(),
                      style: GoogleFonts.lato(
                        color: LABEL_COLOR,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      product.description,
                      style: GoogleFonts.ibmPlexSans(
                          color: LABEL_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      minWidth: 40,
                      height: 40,
                      color: Colors.grey.shade300,
                      elevation: 0,
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Color",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
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
                          width: 40,
                          height: 40,
                          child: Center(
                            child: _selectedColor == index
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : Container(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Size',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
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
                                  ? Colors.yellow[800]
                                  : Colors.grey.shade200,
                              shape: BoxShape.circle),
                          width: 40,
                          height: 40,
                          child: Center(
                            child: Text(
                              size[index],
                              style: TextStyle(
                                  color: _selectedSize == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Slider Price Renge filter
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Price Range',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '\$ ${selectedRange.start.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                        Text(" - ",
                            style: TextStyle(color: Colors.grey.shade500)),
                        Text(
                          '\$ ${selectedRange.end.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RangeSlider(
                    values: selectedRange,
                    min: 0.00,
                    max: 2000.00,
                    divisions: 100,
                    inactiveColor: Colors.grey.shade300,
                    activeColor: Colors.yellow[800],
                    labels: RangeLabels(
                      '\$ ${selectedRange.start.toStringAsFixed(2)}',
                      '\$ ${selectedRange.end.toStringAsFixed(2)}',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() => selectedRange = values);
                    }),
                const SizedBox(
                  height: 20,
                ),
                button('Filter', () {})
              ],
            ),
          );
        });
      },
    );
  }

  addToCartModal() {
    return showModalBottomSheet(
        context: context,
        transitionAnimationController: AnimationController(
            duration: const Duration(milliseconds: 400), vsync: this),
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 380,
                  padding: EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fabric",
                              style: GoogleFonts.raleway(
                                height: 1.5,
                                color: LABEL_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            BulletList(const [
                              "5.3 oz., 100% preshrunk cotton",
                              "Made with sustainably and fairly grown USA cotton",
                            ]),
                            Text(
                              "Feature",
                              style: GoogleFonts.raleway(
                                height: 1.5,
                                color: LABEL_COLOR,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            BulletList(const [
                              "Seamless rib at neck",
                              "Taped shoulder-to-shoulder",
                              "Double-needle stitching throughout",
                              '"7/8" collar',
                            ]),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Available Colors",
                          style: GoogleFonts.raleway(
                              color: LABEL_COLOR,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Container(
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
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.only(right: 10),
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
                                            size: 18,
                                          )
                                        : Container(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Available Sizes",
                          style: GoogleFonts.raleway(
                              color: LABEL_COLOR,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
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
                                  duration: const Duration(milliseconds: 500),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color: _selectedSize == index
                                          ? Colors.yellow[800]
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle),
                                  width: 30,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      size[index],
                                      style: GoogleFonts.raleway(
                                          color: _selectedSize == index
                                              ? Colors.white
                                              : LABEL_COLOR,
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);

                            // Let's show a snackbar when an item is added to the cart
                            final snackbar = SnackBar(
                              content: const Text("Item added to cart"),
                              duration: Duration(seconds: 5),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {},
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.black,
                          child: const Center(
                            child: Text(
                              "Add to Cart",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ));
  }

  button(String text, Function onPressed) {
    return MaterialButton(
      onPressed: () => onPressed(),
      height: 50,
      elevation: 0,
      splashColor: Colors.yellow[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.yellow[800],
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
