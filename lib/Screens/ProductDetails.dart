import 'package:apparel_options/Components/BulletList.dart';
import 'package:apparel_options/Constants/constantColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Constants/myColors.dart';
import '../Model/MenuModel.dart';
import '../Model/ProductNew.dart';
import '../animation/FadeAnimation.dart';

class ProductDetails extends StatefulWidget {
  final ProductNew ?product;
  final MenuModel? menuItem;
  const ProductDetails({Key? key, this.product, this.menuItem})
      : super(key: key);

  @override
  _ProductDetailsState createState() =>
      _ProductDetailsState(product: product!, menuItem: menuItem!);
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  final ProductNew? product;
  final MenuModel? menuItem;

  int selectedImage = 0;

  int newLength = 2;

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
    const Color(0xFFFFC1D9),
  ];

  int _selectedColor = 0;
  int _selectedSize = 1;

  _ProductDetailsState({this.product, this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "",
            style: GoogleFonts.raleway(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: .75,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 19,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 238,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: widget.menuItem!.id.toString(),
                      child: Image.network(widget.menuItem!.imageUrl!),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(widget.menuItem!.imageUrl!.length,
                        (index) => buildSmallProductPreview(index)),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: kBackgroundTheme,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.menuItem!.product!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "GHC " + widget.menuItem!.price.toString(),
                                // "Pricing upon request",
                                style: GoogleFonts.lato(
                                  color: Colors.teal,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
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
                      const Divider(
                        thickness: 0.16,
                        color: Colors.black54,
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 0),
                          height: 260,
                          child: Column(children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Similar Products',
                                  style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 2,
                                    itemBuilder: (context, index) {
                                      return productCart(demoProducts[index]);
                                    }))
                          ])),
                      const SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          height: 50,
                          elevation: 0,
                          splashColor: Colors.yellow[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "Add to Cart",
                              style: GoogleFonts.lato(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  productCart(ProductNew product) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GestureDetector(
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
                          child: Image.network(product.images![0],
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
                  product.title!,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      )
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
                                            size: 12,
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

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.teal.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.menuItem!.imageUrl![index]),
      ),
    );
  }

  GestureDetector buildSmallProductPreviewOne(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.teal.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.product!.images![index]),
      ),
    );
  }
}
